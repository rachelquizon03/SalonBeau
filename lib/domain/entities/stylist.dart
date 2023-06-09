class Stylist {
  const Stylist({
    required this.salonId,
    required this.stylist,
    this.id,
  });

  final String salonId;
  final String stylist;
  final String? id;

  Map<String, dynamic> toJson() {
    return {
      'salonId': salonId,
      'stylist': stylist,
    };
  }

  static fromJson(data) {
    return Stylist(
      salonId: data['salonId'],
      stylist: data['stylist'],
      id: data['id'],
    );
  }
}
