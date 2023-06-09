import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salon_app/app/pages/appointment_schedules/review_add_view.dart';
import 'package:salon_app/app/widgets/dialog.dart';
import 'package:salon_app/data/appointment_repository.dart';
import 'package:salon_app/data/auth_repository.dart';
import 'package:salon_app/data/ratings_repository.dart';
import 'package:salon_app/domain/entities/appointment.dart';

class AppointmentSchedulesView extends StatefulWidget {
  const AppointmentSchedulesView({super.key});

  @override
  State<AppointmentSchedulesView> createState() =>
      _AppointmentSchedulesViewState();
}

class _AppointmentSchedulesViewState extends State<AppointmentSchedulesView> {
  List<Appointment> _appointments = [];

  void loadAppointments() async {
    final customer = AuthRepository.customer!;
    final appointments =
        await AppointmentRepository().getAppointmentsByEmail(customer.email);
    setState(() {
      _appointments = appointments;
    });
  }

  @override
  void initState() {
    loadAppointments();
    super.initState();
  }

  void handleBack() {
    Navigator.of(context).pop();
  }

  void handleRate(Appointment appointment) async {
    if (appointment.progress != Appointment.acceptedProgress) {
      showOkDialog(
        context: context,
        titleText: 'Unable to leave a review',
        contentText: 'Appointment should be accepted before making a review.',
      );
      return;
    }
    if (appointment.feedbackId.isNotEmpty) {
      final feedback = await RatingsRepository().getRatingById(appointment.feedbackId);
      showOkDialog(
        context: context,
        titleText: 'Stars: ${feedback.star}',
        contentText: feedback.review,
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewAddView(appointment: appointment),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFFFD9ED),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 25.0,
                horizontal: 15.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: handleBack,
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Color(0xFFC93480),
                              size: 28.0,
                            ),
                          ),
                          const Text(
                            'Appointments',
                            style: TextStyle(
                              color: Color(0xFFC93480),
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  ..._appointments.map(
                    (appointment) => AppointmentCard(
                      data: appointment,
                      onRate: () => handleRate(appointment),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.data,
    this.onRate,
  });

  final Appointment data;
  final Function()? onRate;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Container(
        padding: const EdgeInsets.only(
          left: 25.0,
          top: 15.0,
          right: 25.0,
          bottom: 15.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.name,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Service',
                  style: TextStyle(color: Colors.black54),
                ),
                Text(
                  data.service,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Stylist',
                  style: TextStyle(color: Colors.black54),
                ),
                Text(
                  data.stylist,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Date',
                  style: TextStyle(color: Colors.black54),
                ),
                Text(
                  data.date,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Time',
                  style: TextStyle(color: Colors.black54),
                ),
                Text(
                  data.time,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status: ${data.progress.toUpperCase()}',
                  style: const TextStyle(color: Colors.black87),
                ),
                OutlinedButton(
                  onPressed: onRate,
                  child: const Text('Review'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
