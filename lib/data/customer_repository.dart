import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_app/domain/entities/customer.dart';

class CustomerRepository {
  Future<Customer> getCustomerByUid(uid) async {
    final customer = (await FirebaseFirestore.instance
            .collection("customer")
            .where('uid', isEqualTo: uid)
            .get())
        .docs
        .first;
    final data = customer.data();
    return Customer(
      id: customer.id,
      uid: data['uid'],
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      gender: data['gender'],
      type: data['type'],
    );
  }
}
