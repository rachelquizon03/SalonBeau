import 'package:flutter/material.dart';
import 'package:salon_app/data/auth_repository.dart';

class VerifyPopup extends StatelessWidget {
  VerifyPopup({super.key});

  void showVerificationSentPopup(BuildContext context){
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text("Check your inbox for your verification"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Close"),
        )
      ],
    ));
  }

  void verify(BuildContext context){
    Navigator.pop(context);
    AuthRepository().sendEmailVerification()
      .whenComplete(() => showVerificationSentPopup(context));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AlertDialog(
      title: Text("Verify Your Email Now", textAlign: TextAlign.center,),
      content: Container(
        // width: size.width * 0.8,
        // height: 200,
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: Text("Verify your email to access additional features"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Remind me later"),
        ),
        TextButton(
          onPressed: () => verify(context),
          child: Text("Verify now"),
        ),
      ],
    );
  }
}