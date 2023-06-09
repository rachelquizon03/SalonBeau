class Customer {
  Customer({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.type,
    this.emailVerified,
    this.uid,
    this.id,
  });

  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final String type;

  final String? uid;
  final String? id;
  final bool? emailVerified;

  static const customerType = 'customer';
  static const salonType = 'salon';

  Map<String, dynamic> toJSON() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'type': type,
    };
  }
}
