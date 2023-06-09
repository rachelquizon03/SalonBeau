import 'package:flutter/material.dart';
import 'package:salon_app/app/pages/profile/widgets/app_elevated_button.dart';
import 'package:salon_app/app/pages/startup/startup_view.dart';

class SalonSignupSuccessfulView extends StatefulWidget {
  const SalonSignupSuccessfulView({super.key});

  @override
  State<SalonSignupSuccessfulView> createState() =>
      _SalonSignupSuccessfulViewState();
}

class _SalonSignupSuccessfulViewState extends State<SalonSignupSuccessfulView> {
  void handleReload() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const StartupView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'Successfully created a Salon!',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 25.0),
              AppElevatedButton(
                onPressed: handleReload,
                child: const Text('Reload the app'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
