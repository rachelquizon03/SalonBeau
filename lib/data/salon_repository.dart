import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_app/domain/entities/customer.dart';
import 'package:salon_app/domain/entities/salon.dart';

class SalonRepository {
  static Salon? salon; // for auth purposes

  Future<List<Salon>> getSalons() async {
    final salons = await FirebaseFirestore.instance.collection("salon").get();
    final List<Salon> data = [];
    for (final salon in salons.docs) {
      final salonData = salon.data();
      final laaganTrainee = Salon.fromJSON({...salonData, 'id': salon.id});
      data.add(laaganTrainee);
    }
    return data;
  }

  Future<List<Salon>> getPublishedSalons() async {
    final List<Salon> salons = await getSalons();
    return salons.where((salon) => salon.published).toList();
  }

  Future<List<Salon>> getSortedPublishedSalons() async {
    final List<Salon> salons = await getSalons();
    salons.where((salon) => salon.published).toList();
    salons.sort((b, a) => a.getTotalRatings().compareTo(b.getTotalRatings()),);
    return salons;
  }

  Future<Salon> getSalonByUid(uid) async {
    final salonSnapshot = await FirebaseFirestore.instance
        .collection("salon")
        .where("uid", isEqualTo: uid)
        .get();
    final salonDoc = salonSnapshot.docs.first;
    final salonData = salonDoc.data();
    final salon = Salon.fromJSON({...salonData, 'id': salonDoc.id});
    SalonRepository.salon = salon;
    return salon;
  }

  Future<Salon> addSalon(Salon salon) async {
    await FirebaseFirestore.instance.collection("salon").add({
      'createdAt': Timestamp.now(),
      ...salon.toJSON(),
    });
    final customerSnapshot = (await FirebaseFirestore.instance
            .collection("customer")
            .where("uid", isEqualTo: salon.uid)
            .get())
        .docs
        .first;
    await customerSnapshot.reference.set(
      {'type': Customer.salonType},
      SetOptions(merge: true),
    );
    return salon;
  }

  Future<Salon> setSalonPublish(Salon salon) async {
    await FirebaseFirestore.instance.collection("salon").doc(salon.id).set(
      {'published': true},
      SetOptions(merge: true),
    );
    return salon;
  }
}
