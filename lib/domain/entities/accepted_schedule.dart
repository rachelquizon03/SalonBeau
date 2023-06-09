import 'package:cloud_firestore/cloud_firestore.dart';

class AcceptedSchedule{
  final String stylist;
  final Timestamp createdAt;
  final String name;

  AcceptedSchedule({
    required this.stylist,
    required this.createdAt,
    required this.name
  });

  static Map<String, dynamic> toJSON(AcceptedSchedule model){
    return {
      'stylist': model.stylist,
      'name': model.name,
      'created_at': model.createdAt
    };
  }

  static AcceptedSchedule fromJSON(Map<String, dynamic> json){
    return AcceptedSchedule(
      stylist: json['stylist'],
      name: json['name'],
      createdAt: json['created_at']
    );
  }
}