import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salon_app/app/pages/appointment_info/appointment_info_successful_view.dart';
import 'package:salon_app/app/pages/profile/widgets/app_elevated_button.dart';
import 'package:salon_app/app/pages/signin/signin_view.dart';
import 'package:salon_app/app/pages/signup/signup_successful_view.dart';
import 'package:salon_app/data/auth_repository.dart';
import 'package:salon_app/domain/entities/customer.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final _genderItems = ['Male', 'Female', 'Prefer not to say'];

  // for validation purposes only
  final TextEditingController _passwordController = TextEditingController();
  final Map<String, String> _data = {};

  bool _obscurePassword = true;

  // for auth errors
  String? _emailErrorText;
  String? _passwordErrorText;

  void _toggleObscure() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _handleCreate() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final customer = Customer(
        email: _data['email']!,
        firstName: _data['firstName']!,
        lastName: _data['lastName']!,
        gender: _data['gender']!,
        type: 'customer',
      );
      final password = _data['password']!;

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
                  Text('Creating an account'),
                ],
              ),
            ),
          );
        },
      );

      try {
        setState(() {
          _emailErrorText = null;
          _passwordErrorText = null;
        });
        await AuthRepository().signup(customer, password);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SignupSuccessfulView(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          setState(() => _emailErrorText = 'Email already in use');
        } else if (e.code == 'invalid-email') {
          setState(() => _emailErrorText = 'Invalid email');
        } else if (e.code == 'weak-password') {
          setState(() => _passwordErrorText = 'Weak password');
        }
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
      }
    }
  }

  void handleSignIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SigninView(),
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
              child: Form(
                key: _formKey,
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
                          'Sign Up',
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
                        child: Column(
                          children: [
                            TextFormField(
                              onSaved: (newValue) =>
                                  _data['firstName'] = newValue!,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please input first name';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'First Name',
                              ),
                            ),
                            TextFormField(
                              onSaved: (newValue) =>
                                  _data['lastName'] = newValue!,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please input last name';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Last Name',
                              ),
                            ),
                            DropdownButtonFormField(
                              onSaved: (newValue) =>
                                  _data['gender'] = newValue!,
                              decoration: const InputDecoration(
                                labelText: 'Gender',
                              ),
                              onChanged: (value) {},
                              items: _genderItems.map((genderItem) {
                                return DropdownMenuItem(
                                  value: genderItem,
                                  child: Text(genderItem),
                                );
                              }).toList(),
                            ),
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
                            TextFormField(
                              obscureText: _obscurePassword,
                              controller: _passwordController,
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
                                errorText: _passwordErrorText,
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: _toggleObscure,
                                ),
                              ),
                            ),
                            TextFormField(
                              obscureText: _obscurePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please input confirm password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Please input correct confirm password';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  border: const UnderlineInputBorder(),
                                  labelText: 'Confirm Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: _toggleObscure,
                                  )),
                            ),
                            const SizedBox(height: 15.0),
                            AppElevatedButton(
                              onPressed: _handleCreate,
                              child: const Text('Create an account'),
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
