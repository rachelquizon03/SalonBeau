import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_app/domain/entities/stylist.dart';

class StylistRepository {
  Future<Stylist> addStylist(Stylist stylist) async {
    await FirebaseFirestore.instance.collection("stylist").add({
      'createdAt': Timestamp.now(),
      ...stylist.toJson(),
    });
    return stylist;
  }

  Future<List<Stylist>> getStylists() async {
    final snapshot =
        await FirebaseFirestore.instance.collection("stylist").get();
    final List<Stylist> data = [];
    for (final docSnapshot in snapshot.docs) {
      final snapshotData = docSnapshot.data();
      data.add(Stylist.fromJson({...snapshotData, 'id': docSnapshot.id}));
    }
    return data;
  }

  Future<List<Stylist>> getStylistsByUid(uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("stylist")
        .where('salonId', isEqualTo: uid)
        .get();
    final List<Stylist> data = [];
    for (final doc in snapshot.docs) {
      final docData = doc.data();
      data.add(Stylist.fromJson({...docData, 'id': doc.id}));
    }
    return data;
  }

  Future<void> deleteStylist(Stylist stylist) async {
    await FirebaseFirestore.instance
        .collection("stylist")
        .doc(stylist.id)
        .delete();
  }

  Future<Stylist> editStylist(Stylist stylist) async {
    await FirebaseFirestore.instance.collection("stylist").doc(stylist.id).set({
      'modifiedAt': Timestamp.now(),
      ...stylist.toJson(),
    });
    return stylist;
  }
}
