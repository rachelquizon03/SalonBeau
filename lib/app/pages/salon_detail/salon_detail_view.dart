import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salon_app/app/pages/appointment_info/appointment_info_view.dart';
import 'package:salon_app/app/pages/profile/widgets/app_elevated_button.dart';
import 'package:salon_app/app/widgets/dialog.dart';
import 'package:salon_app/data/auth_repository.dart';
// import 'package:salon_app/data/salon_repository.dart';
import 'package:salon_app/data/schedule_repository.dart';
import 'package:salon_app/domain/entities/salon.dart';
import 'package:salon_app/domain/entities/schedule.dart';

class SalonDetailView extends StatefulWidget {
  const SalonDetailView({super.key, required this.salon});
  final Salon salon;
  @override
  State<SalonDetailView> createState() => _SalonDetailViewState();
}

class _SalonDetailViewState extends State<SalonDetailView> {
  Schedule? _schedule;

  // final weekDays = [
  //   "Sunday",
  //   "Monday",
  //   "Tuesday",
  //   "Wednesday",
  //   "Thursday",
  //   "Friday",
  //   "Saturday"
  // ];

  // dynamic get positions => weekDays.asMap().map((ind, day) => MapEntry(day, ind));

  void loadSalon() async {
    final weekDays = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ];

    var positions = weekDays.asMap().map((ind, day) => MapEntry(day, ind));

    final schedule =
        await ScheduleRepository().getScheduleByUid(widget.salon.id);
        schedule.blocks.sort((first, second) {
          final firstPos = positions[first.day.capitalize()] ?? 8;
          final secondPos = positions[second.day.capitalize()] ?? 8;
          return firstPos.compareTo(secondPos);
        });
    setState(() {
      _schedule = schedule;
    });
  }

  @override
  void initState() {
    loadSalon();
    super.initState();
  }

  void handleBack() {
    Navigator.of(context).pop();
  }

  void handleMake() async {
    var user = FirebaseAuth.instance.currentUser;

    if(user != null && !user.emailVerified) await user.reload();

    if (AuthRepository.customer == null) {
      showOkDialog(
        context: context,
        titleText: 'Unable to make appointment',
        contentText: 'Please login as a customer',
      );
      return;
    }

    if (AuthRepository().isVerified == false && AuthRepository().isLoggedIn == true) {
      showOkDialog(
        context: context,
        titleText: 'Unable to make appointment',
        contentText: 'Please verify your email',
      );
      return;
    }

    final customerId = AuthRepository.customer!.uid;
    if (customerId == widget.salon.uid) {
      showOkDialog(
        context: context,
        titleText: 'Unable to make appointment',
        contentText:
            'Salon is restricted to make appointment from their branch',
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentInfoView(salon: widget.salon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFFFD9ED),
        padding: const EdgeInsets.symmetric(
          vertical: 25.0,
          horizontal: 15.0,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
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
                    Expanded(
                      child: Text(
                        widget.salon.salonName,
                        style: const TextStyle(
                          color: Color(0xFFC93480),
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25.0),
                Image.network(widget.salon.logoUrl),
                const SizedBox(height: 25.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star_outline),
                    const SizedBox(width: 5.0),
                    Text(
                      'Rating: ${widget.salon.getTotalRatings()}',
                      style: const TextStyle(fontSize: 21.0),
                    ),
                  ],
                ),
                const SizedBox(height: 25.0),
                AppElevatedButton(
                  onPressed: handleMake,
                  child: const Text('Make Appointment'),
                ),
                const SizedBox(height: 25.0),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    bottom: 25.0,
                    left: 25.0,
                    right: 25.0,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFBADD1),
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Salon Schedule',
                            style: TextStyle(
                              color: Color(0xFFC93480),
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          Icon(
                            Icons.schedule,
                            color: Color(0xFFC93480),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      // if (_schedule != null)
                      //   ..._schedule!.blocks
                      //       .map((block) => ScheduleBlockCard(data: block))
                      //       .toList()
                      _schedule != null
                        ? Column(
                          children: List.generate(_schedule!.blocks.length, (index) {
                            return ScheduleBlockCard(data: _schedule!.blocks[index]);
                          }),
                        )
                        : Container()
                    ],
                  ),
                ),
                const SizedBox(height: 25.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScheduleBlockCard extends StatelessWidget {
  const ScheduleBlockCard({super.key, required this.data});
  final ScheduleBlock data;
  @override
  Widget build(BuildContext context) {
    final timeData =
        '${DateFormat.jm().format(data.startTime)} - ${DateFormat.jm().format(data.endTime)}';
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              data.day.capitalize(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(timeData),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
