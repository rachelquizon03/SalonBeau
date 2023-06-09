import 'package:flutter/material.dart';
import 'package:salon_app/app/pages/profile/profile_view.dart';
import 'package:salon_app/app/pages/profile/widgets/app_elevated_button.dart';

class ForgotPasswordSuccessfulView extends StatefulWidget {
  const ForgotPasswordSuccessfulView({super.key});

  @override
  State<ForgotPasswordSuccessfulView> createState() =>
      _ForgotPasswordSuccessfulViewState();
}

class _ForgotPasswordSuccessfulViewState
    extends State<ForgotPasswordSuccessfulView> {
  void handleProfile() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileView(),
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
                'Successfully sent a password reset email!',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 25.0),
              AppElevatedButton(
                onPressed: handleProfile,
                child: const Text('Go back to Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
