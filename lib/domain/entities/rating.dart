class Rating {
  Rating({
    required this.customerId,
    required this.review,
    required this.salonId,
    required this.star,
    this.id,
  });

  final String customerId;
  final String review;
  final String salonId;
  final String star;

  final String? id;

  Map<String, dynamic> toJSON() {
    return {
      'customerID': customerId,
      'review': review,
      'salonId': salonId,
      'star': star,
    };
  }

  static fromJson(data) {
    return Rating(
      customerId: data['customerID'],
      review: data['review'],
      salonId: data['salonId'],
      star: data['star'],
      id: data['id'],
    );
  }
}
