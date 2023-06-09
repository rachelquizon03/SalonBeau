import 'package:flutter/material.dart';
import 'package:salon_app/app/pages/discovery/discovery_view.dart';
import 'package:salon_app/app/pages/profile/widgets/app_elevated_button.dart';

class LogoutView extends StatefulWidget {
  const LogoutView({super.key});

  @override
  State<LogoutView> createState() => _LogoutViewState();
}

class _LogoutViewState extends State<LogoutView> {
  void handleBack() {
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const DiscoveryView(),
    //   ),
    // );
    Navigator.popUntil(context, (route) => route.isFirst);
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
                  'You have been logged out!',
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
