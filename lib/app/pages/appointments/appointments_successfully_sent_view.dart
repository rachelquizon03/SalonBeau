import 'package:flutter/material.dart';
import 'package:salon_app/app/pages/appointments/appointments_view.dart';
import 'package:salon_app/app/pages/profile/widgets/app_elevated_button.dart';

class AppointmentsSuccessfulSentView extends StatefulWidget {
  const AppointmentsSuccessfulSentView({super.key});

  @override
  State<AppointmentsSuccessfulSentView> createState() =>
      AppointmentsSuccessfulSentViewState();
}

class AppointmentsSuccessfulSentViewState
    extends State<AppointmentsSuccessfulSentView> {
  void handleBack() {
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const AppointmentsView(),
    //   ),
    // );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await Future.value(false),
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(15.0),
          color: const Color(0xFFFFD9ED),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFFC93480),
                  size: 96.0,
                ),
                const SizedBox(height: 15.0),
                const Text(
                  'Successfully sent an acceptance/rejected email!',
                  style: TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 25.0),
                AppElevatedButton(
                  onPressed: handleBack,
                  child: const Text('Go back to Appointments'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
