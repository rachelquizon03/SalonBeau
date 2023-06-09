import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salon_app/app/pages/appointments/appointments_successfully_sent_view.dart';
import 'package:salon_app/app/widgets/dialog.dart';
import 'package:salon_app/data/appointment_repository.dart';
import 'package:salon_app/data/salon_repository.dart';
import 'package:salon_app/domain/entities/appointment.dart';

class AppointmentsView extends StatefulWidget {
  const AppointmentsView({super.key});

  @override
  State<AppointmentsView> createState() => _AppointmentsViewState();
}

class _AppointmentsViewState extends State<AppointmentsView> {
  List<Appointment> _appointments = [];

  void loadAppointments() async {
    var appointments = await AppointmentRepository()
        .getAppointmentsByUid(SalonRepository.salon!.id);
    final emptyAppointments = appointments.where((appointment) => appointment.progress.isEmpty).toList();
    setState(() {
      _appointments = emptyAppointments;
    });
  }

  @override
  void initState() {
    // loadAppointments();
    super.initState();
  }

  void handleBack() {
    Navigator.of(context).pop();
  }

  void handleAccept(Appointment appointment) {
    showAlertDialog(
      context: context,
      titleText: 'Confirm Accept',
      contentText: 'Are you sure you want to accept?',
      onContinue: () async {
        Navigator.of(context).pop();
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 15.0),
                    Text('Sending an acceptance email'),
                  ],
                ),
              ),
            );
          },
        );
        try {
          var result = await AppointmentRepository().setAppointmentAccept(appointment);
          if(result.isSuccess){
            await AppointmentRepository()
              .sendEmailAccept(appointment, SalonRepository.salon!.salonName);
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const AppointmentsSuccessfulSentView(),
            //   ),
            // );
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AppointmentsSuccessfulSentView()));
          }
          else{
            Navigator.pop(context);
            showDialog(context: context, builder: (context) => AlertDialog(
              title: Text("Appointment Failed"),
              content: Text("Stylist is busy at the scheduled time. Please tap REJECT button to notify the client"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Close"),
                )
              ],
            ));
          }
        } catch (err) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  void handleReject(Appointment appointment) {
    showAlertDialog(
      context: context,
      titleText: 'Confirm Reject',
      contentText: 'Are you sure you want to reject?',
      onContinue: () async {
        Navigator.of(context).pop();
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 15.0),
                    Text('Sending a rejected email'),
                  ],
                ),
              ),
            );
          },
        );
        try {
          await AppointmentRepository().setAppointmentReject(appointment);
          await AppointmentRepository()
              .sendEmailReject(appointment, SalonRepository.salon!.salonName);
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const AppointmentsSuccessfulSentView(),
          //   ),
          // );
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AppointmentsSuccessfulSentView()));
        } catch (err) {
          Navigator.of(context).pop();
        }
      },
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
                  // const SizedBox(height: 15.0),
                  // ..._appointments.map(
                  //   (appointment) => AppointmentCard(
                  //     data: appointment,
                  //     onAccept: handleAccept,
                  //     onReject: handleReject,
                  //   ),
                  // ),
                  StreamBuilder<List<Appointment>>(
                    stream: AppointmentRepository().salonAppointmentStream(SalonRepository.salon!.id ?? ""),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        return Column(
                          children: List.generate(snapshot.data!.length, (index) => AppointmentCard(
                            data: snapshot.data![index],
                            onAccept: handleAccept,
                            onReject: handleReject,
                          )),
                        );
                      }

                      return Container();
                    },
                  )
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
    this.onAccept,
    this.onReject,
  });

  final Appointment data;
  final Function(Appointment)? onAccept;
  final Function(Appointment)? onReject;

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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => onReject?.call(data),
                  child: const Text('Reject'),
                ),
                const SizedBox(width: 15.0),
                OutlinedButton(
                  onPressed: () => onAccept?.call(data),
                  child: const Text('Accept'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
