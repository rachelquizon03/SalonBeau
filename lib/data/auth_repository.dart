import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_app/domain/entities/customer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  static Customer? customer; // for auth purposes

  bool isVerified = FirebaseAuth.instance.currentUser != null
    ? FirebaseAuth.instance.currentUser!.emailVerified
    : false;
  bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

  Future<UserCredential> signup(Customer customer, String password) async {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: customer.email,
      password: password,
    );
    if (credential.user != null) {
      await credential.user!.sendEmailVerification();
    }
    await FirebaseFirestore.instance.collection("customer").add({
      'createdAt': Timestamp.now(),
      'uid': credential.user!.uid,
      ...customer.toJSON(),
    });
    return credential;
  }

  Future<Customer> signIn(String email, String password) async {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    final uid = credential.user!.uid;
    final customerSnapshot = (await FirebaseFirestore.instance
            .collection("customer")
            .where("uid", isEqualTo: uid)
            .get())
        .docs
        .first;
    final customerData = customerSnapshot.data();
    final customer = Customer(
      id: customerSnapshot.id,
      uid: customerData['uid'],
      email: customerData['email'],
      firstName: customerData['firstName'],
      lastName: customerData['lastName'],
      type: customerData['type'],
      gender: customerData['gender'] ?? '',
      emailVerified: credential.user!.emailVerified,
    );
    AuthRepository.customer = customer;
    return customer;
  }

  Future<void> reload() async {
    final user = await FirebaseAuth.instance.authStateChanges().first;
    if (user != null) {
      final customerSnapshot = (await FirebaseFirestore.instance
              .collection("customer")
              .where("uid", isEqualTo: user.uid)
              .get())
          .docs
          .first;
      final customerData = customerSnapshot.data();
      final customer = Customer(
        id: customerSnapshot.id,
        uid: customerData['uid'],
        email: customerData['email'],
        firstName: customerData['firstName'],
        lastName: customerData['lastName'],
        type: customerData['type'],
        gender: customerData['gender'] ?? '',
        emailVerified: user.emailVerified,
      );
      AuthRepository.customer = customer;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    AuthRepository.customer = null;
  }

  Future<void> sendPasswordReset(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> sendEmailVerification() async {
    if(FirebaseAuth.instance.currentUser != null){
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    }
  }
}
