import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salon_app/app/pages/profile/widgets/app_elevated_button.dart';
import 'package:salon_app/app/pages/salon_signup/salon_signup_successful_view.dart';
import 'package:salon_app/app/widgets/dialog.dart';
import 'package:salon_app/data/auth_repository.dart';
import 'package:salon_app/data/salon_repository.dart';
import 'package:salon_app/domain/entities/customer.dart';
import 'package:salon_app/domain/entities/salon.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SalonSignupView extends StatefulWidget {
  const SalonSignupView({super.key});

  @override
  State<SalonSignupView> createState() => _SalonSignupViewState();
}

class _SalonSignupViewState extends State<SalonSignupView> {
  final Customer _customer = AuthRepository.customer!;
  File? _image;
  String? _fileName;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _data = {};

  final _emailController = TextEditingController();

  bool _termsAndConditions = false;

  @override
  void initState() {
    _emailController.text = _customer.email;
    super.initState();
  }

  void handleSignup() async {
    if (!_termsAndConditions) {
      showOkDialog(
        context: context,
        titleText: 'Terms and Conditions',
        contentText: 'Please read and tick the terms and conditions',
      );
      return;
    }

    if (_image == null) {
      showOkDialog(
        context: context,
        titleText: 'Unable to Signup',
        contentText: 'Please upload a logo to proceed',
      );
      return;
    }

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
                  Text('Creating a Salon'),
                ],
              ),
            ),
          );
        },
      );

      try {
        final firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child("images/$_fileName");
        final firebase_storage.UploadTask uploadTask = ref.putFile(_image!);
        final snapshot = await uploadTask.whenComplete(() {});
        final String url = await snapshot.ref.getDownloadURL();
        final contactNumber = int.parse(_data['contactNumber']);
        await SalonRepository().addSalon(
          Salon(
            salonName: _data['salonName'],
            salonLocation: _data['salonName'],
            businessRegistration: _data['businessRegistration'],
            email: _data['email'],
            logoUrl: url,
            contactNumber: contactNumber,
            uid: _customer.uid,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SalonSignupSuccessfulView(),
          ),
        );
      } catch (e) {
        Navigator.of(context).pop();
      }
    }
  }

  void handleUpload() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        String fileName = File(pickedFile.path).path.split('/').last;
        _fileName = fileName;
      } else {
        print('No image selected.');
      }
    });
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
                  const SizedBox(height: 56.0),
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
                              onSaved: (newValue) =>
                                  _data['salonName'] = newValue!,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please input salon name';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Salon Name',
                              ),
                            ),
                            TextFormField(
                              onSaved: (newValue) =>
                                  _data['salonLocation'] = newValue!,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please input address';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Address',
                              ),
                            ),
                            TextFormField(
                              onSaved: (newValue) =>
                                  _data['contactNumber'] = newValue!,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please input contact number';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Contact Number',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              enabled: false,
                              controller: _emailController,
                              onSaved: (newValue) => _data['email'] = newValue!,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please input email';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Email',
                              ),
                            ),
                            TextFormField(
                              onSaved: (newValue) =>
                                  _data['businessRegistration'] = newValue!,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please input business registration';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Business Registration',
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            _image == null
                                ? Container()
                                : Image.file(
                                    _image!,
                                    height: 200,
                                    fit: BoxFit.fitHeight,
                                  ),
                            const SizedBox(height: 15.0),
                            AppElevatedButton(
                              onPressed: handleUpload,
                              child: const Text('Upload Logo'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _termsAndConditions,
                        onChanged: (e) => setState(() {
                          if (e != null) {
                            _termsAndConditions = e;
                          }
                        }),
                      ),
                      const Text('I agree in all terms and conditions'),
                    ],
                  ),
                  AppElevatedButton(
                    onPressed: handleSignup,
                    child: const Text('Start your journey'),
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
