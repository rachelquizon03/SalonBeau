import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_app/domain/entities/appointment.dart';
import 'package:http/http.dart' as http;
import 'package:salon_app/domain/entities/appointment_status.dart';
import 'package:salon_app/env.dart';

class AppointmentRepository {
  Future<List<Appointment>> getAppointmentsByUid(uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("Appointment")
        .where('salonId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .orderBy('time')
        .get();
    final List<Appointment> data = [];
    for (final doc in snapshot.docs) {
      final docData = doc.data();
      data.add(Appointment.fromJson({...docData, 'id': doc.id}));
    }
    return data;
  }

  Stream<List<Appointment>> salonAppointmentStream(String salonID){
    try{
      final snapshot = FirebaseFirestore.instance
          .collection("Appointment")
          .where('salonId', isEqualTo: salonID)
          .where('progress', isEqualTo: "")
          .orderBy('createdAt', descending: true)
          // .orderBy('time')
          .snapshots().map((event) {
            final List<Appointment> data = [];
            for (final doc in event.docs) {
              final docData = doc.data();
              data.add(Appointment.fromJson({...docData, 'id': doc.id}));
            }
            return data;
          });
      return snapshot;
    }
    catch(e){
      print(e);
      return Stream.value(<Appointment>[]);
    }
  }

  Future<List<Appointment>> getAppointmentsByEmail(email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("Appointment")
        .where('email', isEqualTo: email)
        .orderBy('createdAt', descending: true)
        .get();
    final List<Appointment> data = [];
    for (final doc in snapshot.docs) {
      final docData = doc.data();
      data.add(Appointment.fromJson({...docData, 'id': doc.id}));
    }
    return data;
  }

  Future<AppointmentStatus> addAppointment(Appointment appointment) async {
    // await FirebaseFirestore.instance.collection("Appointment").add({
    //   'createdAt': Timestamp.now(),
    //   ...appointment.toJSON(),
    // });
    var result = await FirebaseFirestore.instance.collection("Appointment")
      .where('salonId', isEqualTo: appointment.salonId)
      .where('progress', isEqualTo: "accepted")
      .where('stylist', isEqualTo: appointment.stylist)
      .where('date', isEqualTo: appointment.date)
      .where('time', isEqualTo: appointment.time)
      .get();
    
    if(result.docs.isNotEmpty){
      return AppointmentStatus(appointment: appointment, isSuccess: false);
    }
    else{
      await FirebaseFirestore.instance.collection("Appointment").add({
        'createdAt': Timestamp.now(),
        ...appointment.toJSON(),
      });
    }
    return AppointmentStatus(appointment: appointment, isSuccess: true);
  }

  Future<AppointmentStatus> setAppointmentAccept(Appointment appointment) async {
    var result = await FirebaseFirestore.instance.collection("Appointment")
      .where('salonId', isEqualTo: appointment.salonId)
      .where('progress', isEqualTo: "accepted")
      .where('stylist', isEqualTo: appointment.stylist)
      .where('date', isEqualTo: appointment.date)
      .where('time', isEqualTo: appointment.time)
      .get();
    
    if(result.docs.isNotEmpty){
      return AppointmentStatus(appointment: appointment, isSuccess: false);
    }
    {
      await FirebaseFirestore.instance
        .collection("Appointment")
        .doc(appointment.id)
        .set({'progress': Appointment.acceptedProgress}, SetOptions(merge: true));
      
      return AppointmentStatus(appointment: appointment, isSuccess: true);
    }
  }

  Future<void> setAppointmentReject(Appointment appointment) async {
    await FirebaseFirestore.instance
        .collection("Appointment")
        .doc(appointment.id)
        .set({'progress': Appointment.rejectedProgress}, SetOptions(merge: true));
  }

  Future<void> sendEmailAccept(Appointment appointment, salonName) async {
    final emailBody = {
      "personalizations": [
        {
          "to": [
            {"email": appointment.email, "name": appointment.name}
          ],
          "dynamic_template_data": {
            "salon": salonName,
            "name": appointment.name,
            "service": appointment.service,
            "stylist": appointment.stylist,
            "date_time": '${appointment.date} - ${appointment.time}',
          },
        },
      ],
      "template_id": "d-6b739d6092a649a89e8600390016276f",
      "from": {"email": "salonbeau08@gmail.com", "name": "Salon Beau"},
      "reply_to": {"email": "salonbeau08@gmail.com", "name": "Salon Beau"},
    };

    final headers = {
      'Authorization': 'Bearer $sendgridApiKey',
      'Content-Type': 'application/json',
    };

    await http.post(
      Uri.parse('https://api.sendgrid.com/v3/mail/send'),
      headers: headers,
      body: jsonEncode(emailBody),
    );
  }

  Future<void> sendEmailReject(Appointment appointment, salonName) async {
    final emailBody = {
      "personalizations": [
        {
          "to": [
            {"email": appointment.email, "name": appointment.name}
          ],
          "dynamic_template_data": {
            "salon": salonName,
            "name": appointment.name,
            "service": appointment.service,
            "stylist": appointment.stylist,
            "date_time": '${appointment.date} - ${appointment.time}',
          },
        },
      ],
      "template_id": "d-29163b247351434cb6d95c11ea6aadd1",
      "from": {"email": "salonbeau08@gmail.com", "name": "Salon Beau"},
      "reply_to": {"email": "salonbeau08@gmail.com", "name": "Salon Beau"},
    };

    final headers = {
      'Authorization': 'Bearer $sendgridApiKey',
      'Content-Type': 'application/json',
    };

    await http.post(
      Uri.parse('https://api.sendgrid.com/v3/mail/send'),
      headers: headers,
      body: jsonEncode(emailBody),
    );
  }
}
