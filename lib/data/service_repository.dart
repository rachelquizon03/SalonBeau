import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_app/domain/entities/service.dart';

class ServiceRepository {
  Future<Service> addService(Service service) async {
    await FirebaseFirestore.instance.collection("services").add({
      'createdAt': Timestamp.now(),
      ...service.toJson(),
    });
    return service;
  }

  Future<List<Service>> getServicesByUid(uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("services")
        .where('salonId', isEqualTo: uid)
        .get();
    final List<Service> data = [];
    for (final doc in snapshot.docs) {
      final docData = doc.data();
      data.add(Service.fromJson({...docData, 'id': doc.id}));
    }
    return data;
  }

  Future<void> deleteService(Service service) async {
    await FirebaseFirestore.instance
        .collection("services")
        .doc(service.id)
        .delete();
  }

  Future<Service> editService(Service service) async {
    await FirebaseFirestore.instance.collection("services").doc(service.id).set({
      'modifiedAt': Timestamp.now(),
      ...service.toJson(),
    }, SetOptions(merge: true));
    return service;
  }
}
