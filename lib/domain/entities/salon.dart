class Salon {
  Salon({
    required this.salonName,
    required this.salonLocation,
    required this.email,
    required this.contactNumber,
    required this.businessRegistration,
    required this.logoUrl,
    this.ratings = const [],
    this.published = false,
    this.uid,
    this.id,
  });

  final String salonName;
  final String salonLocation;
  final String email;
  final int contactNumber;
  final String businessRegistration;
  final String logoUrl;
  final bool published;
  final List<dynamic> ratings;

  final String? uid;
  final String? id;

  double getTotalRatings() {
    if (ratings.isEmpty) {
      return 0.00;
    }
    var totalRatings = 0.00;
    for (final rating in ratings) {
      totalRatings = totalRatings + double.parse(rating);
    }
    return totalRatings / ratings.length;
  }

  static fromJSON(data) {
    return Salon(
      salonName: data['salonName'],
      salonLocation: data['salonLocation'],
      email: data['email'],
      contactNumber: data['contactNumber'],
      businessRegistration: data['businessRegistration'],
      logoUrl: data['logoUrl'],
      published: data['published'] ?? false,
      ratings: data['ratings'] ?? [],
      uid: data['uid'],
      id: data['id'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'businessRegistration': businessRegistration,
      'contactNumber': contactNumber,
      'email': email,
      'logoUrl': logoUrl,
      'salonLocation': salonLocation,
      'salonName': salonName,
      'uid': uid,
    };
  }
}
