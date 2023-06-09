class Service {
  const Service({
    required this.salonId,
    required this.category,
    required this.cost,
    required this.subCategory,
    this.id,
  });

  final String salonId;
  final String category;
  final double cost;
  final String subCategory;

  final String? id;

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'cost': cost,
      'salonId': salonId,
      'subCategory': subCategory,
    };
  }

  static fromJson(data) {
    return Service(
      category: data['category'],
      cost: data['cost'],
      subCategory: data['subCategory'],
      salonId: data['salonId'],
      id: data['id'],
    );
  }
}
