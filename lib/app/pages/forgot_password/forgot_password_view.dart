import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salon_app/app/pages/appointment_info/appointment_info_successful_view.dart';
import 'package:salon_app/app/pages/forgot_password/forgot_password_successful_view.dart';
import 'package:salon_app/app/pages/profile/widgets/app_elevated_button.dart';
import 'package:salon_app/app/pages/signin/signin_view.dart';
import 'package:salon_app/app/pages/signup/signup_successful_view.dart';
import 'package:salon_app/data/auth_repository.dart';
import 'package:salon_app/domain/entities/customer.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();

  // for validation purposes only
  final Map<String, String> _data = {};

  // for auth errors
  String? _emailErrorText;

  void handleSignIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SigninView(),
      ),
    );
  }

  void handleSend() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

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
                  Text('Sending password reset email'),
                ],
              ),
            ),
          );
        },
      );

      try {
        final email = _data['email'];
        await AuthRepository().sendPasswordReset(email!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ForgotPasswordSuccessfulView(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        print(e.code);
        if (e.code == 'user-not-found') {
          setState(() => _emailErrorText = 'User not found');
        } else {
          setState(
              () => _emailErrorText = 'Unable to send password reset email');
        }
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
      }
    }
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
              padding: const EdgeInsets.all(25.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 56.0),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          children: [
                            TextFormField(
                              onSaved: (newValue) => _data['email'] = newValue!,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please input email';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: const UnderlineInputBorder(),
                                labelText: 'Email',
                                errorText: _emailErrorText,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 15.0),
                            AppElevatedButton(
                              onPressed: handleSend,
                              child: const Text('Send Password Reset'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    const Text(
                      'Already have an account?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: handleSignIn,
                      child: const Text('Sign in'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
