import 'package:flutter/material.dart';
import 'package:salon_app/domain/entities/appointment.dart';

class AppointmentStatus{
  final Appointment appointment;
  final bool isSuccess;

  AppointmentStatus({
    required this.appointment,
    required this.isSuccess
  });
}