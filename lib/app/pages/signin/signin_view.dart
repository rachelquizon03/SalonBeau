import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:salon_app/app/pages/discovery/discovery_view.dart';
import 'package:salon_app/app/pages/forgot_password/forgot_password_view.dart';
import 'package:salon_app/app/pages/profile/widgets/app_elevated_button.dart';
import 'package:salon_app/app/pages/salon_dashboard/salon_dashboard_view.dart';
import 'package:salon_app/app/pages/signup/signup_view.dart';
import 'package:salon_app/data/auth_repository.dart';
import 'package:salon_app/data/customer_repository.dart';
import 'package:salon_app/domain/entities/customer.dart';

class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;

  final Map<String, String> _data = {};

  // for auth errors
  String _errorMessage = "";

  void _toggleObscure() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void handleSignin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if(await InternetConnectionCheckerPlus().hasConnection){
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
                    Text('Signing in'),
                  ],
                ),
              ),
            );
          },
        );

        try {
          setState(() {
            _errorMessage = "";
          });

          final email = _data['email']!;
          final password = _data['password']!;
          final customer = await AuthRepository().signIn(email, password);

          Navigator.of(context).pop();

          if (customer.type == Customer.salonType) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SalonDashboardView(),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const DiscoveryView(),
              ),
            );
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            setState(() => _errorMessage = 'Wrong password');
          } else if (e.code == 'user-not-found') {
            setState(() => _errorMessage = 'User not found');
          }
          else if (e.code == "invalid-email"){
            setState(() {
              _errorMessage = "Invalid email";
            });
          }
          Navigator.of(context).pop();
        } catch (e) {
          setState(() {
            _errorMessage = e.toString();
          });
        }
        print(_errorMessage);
        if(_errorMessage.isNotEmpty) Fluttertoast.showToast(msg: _errorMessage);
      }
      else{
        Fluttertoast.showToast(msg: "No Internet Connection");
      }
    }
  }

  void handleSignup() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SignupView(),
      ),
    );
  }

  void handleForgot() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordView(),
      ),
    );
  }

  void handleBack() {
    Navigator.of(context).pop();
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        'Log In',
                        style: TextStyle(
                          color: Color(0xFFC93480),
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(25.0),
                      child: Form(
                        key: _formKey,
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
                                // errorText: _emailErrorText,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            TextFormField(
                              obscureText: _obscurePassword,
                              onSaved: (newValue) =>
                                  _data['password'] = newValue!,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please input password';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: const UnderlineInputBorder(),
                                labelText: 'Password',
                                // errorText: _passwordErrorText,
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: _toggleObscure,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            AppElevatedButton(
                              onPressed: handleSignin,
                              child: const Text('Sign in'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: handleForgot,
                    child: const Text('Forgot Password?'),
                  ),
                  const SizedBox(height: 25.0),
                  const Text(
                    'Don\'t have an account?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: handleSignup,
                    child: Text('Sign up'),
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
