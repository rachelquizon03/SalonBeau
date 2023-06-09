import 'package:flutter/material.dart';
import 'package:salon_app/data/auth_repository.dart';
import 'package:salon_app/domain/entities/schedule.dart';

showAlertDialog({
  required BuildContext context,
  required String titleText,
  required String contentText,
  required Function()? onContinue,
}) {
  // set up the buttons
  Widget cancelButton = TextButton(
    onPressed: () {
      Navigator.of(context).pop();
    },
    child: const Text("Cancel"),
  );

  Widget continueButton = TextButton(
    onPressed: onContinue,
    child: const Text("Continue"),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(titleText),
    content: Text(contentText),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showLogoutDialog(BuildContext context, Function() onContinue) {
  showAlertDialog(
    context: context,
    titleText: 'Logout',
    contentText: 'You would like to continue logging out from the system?',
    onContinue: () async {
      await AuthRepository().logout();
      onContinue();
    },
  );
}

showOkDialog({
  required BuildContext context,
  required String titleText,
  required String contentText,
}) {
  Widget okButton = TextButton(
    onPressed: () => Navigator.of(context).pop(),
    child: const Text("Ok"),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(titleText),
    content: Text(contentText),
    actions: [okButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<ScheduleBlock?> showScheduleDialog(BuildContext context) async {
  return showDialog<ScheduleBlock>(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: const Text('Select day'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(
                context,
                ScheduleBlock(
                  day: 'monday',
                  startTime: DateTime.now(),
                  endTime: DateTime.now(),
                ),
              );
            },
            child: const Text('Monday'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(
                context,
                ScheduleBlock(
                  day: 'tuesday',
                  startTime: DateTime.now(),
                  endTime: DateTime.now(),
                ),
              );
            },
            child: const Text('Tuesday'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(
                context,
                ScheduleBlock(
                  day: 'wednesday',
                  startTime: DateTime.now(),
                  endTime: DateTime.now(),
                ),
              );
            },
            child: const Text('Wednesday'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(
                context,
                ScheduleBlock(
                  day: 'thursday',
                  startTime: DateTime.now(),
                  endTime: DateTime.now(),
                ),
              );
            },
            child: const Text('Thursday'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(
                context,
                ScheduleBlock(
                  day: 'friday',
                  startTime: DateTime.now(),
                  endTime: DateTime.now(),
                ),
              );
            },
            child: const Text('Friday'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(
                context,
                ScheduleBlock(
                  day: 'saturday',
                  startTime: DateTime.now(),
                  endTime: DateTime.now(),
                ),
              );
            },
            child: const Text('Saturday'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(
                context,
                ScheduleBlock(
                  day: 'sunday',
                  startTime: DateTime.now(),
                  endTime: DateTime.now(),
                ),
              );
            },
            child: const Text('Sunday'),
          ),
        ],
      );
    },
  );
}
