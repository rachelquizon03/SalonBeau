import 'package:flutter/material.dart';
import 'package:salon_app/app/pages/discovery/discovery_view.dart';
import 'package:salon_app/app/pages/profile/profile_view.dart';
import 'package:salon_app/app/pages/profile/widgets/app_elevated_button.dart';
import 'package:salon_app/app/pages/signin/signin_view.dart';

class AppointmentInfoSuccessfulView extends StatefulWidget {
  const AppointmentInfoSuccessfulView({super.key});

  @override
  State<AppointmentInfoSuccessfulView> createState() =>
      _AppointmentInfoSuccessfulViewState();
}

class _AppointmentInfoSuccessfulViewState
    extends State<AppointmentInfoSuccessfulView> {
  void handleBack() {
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const DiscoveryView(),
    //   ),
    // );
    // Navigator.popUntil(context, (route) => route.isFirst && route.isActive);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await Future.value(false);
      },
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
                  'Successfully created an appointment!',
                  style: TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 25.0),
                AppElevatedButton(
                  onPressed: handleBack,
                  child: const Text('Go back to Discovery'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
