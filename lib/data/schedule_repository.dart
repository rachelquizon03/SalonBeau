import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_app/domain/entities/salon.dart';
import 'package:salon_app/domain/entities/schedule.dart';

class ScheduleRepository {
  Future<Schedule> getScheduleByUid(uid) async {
    final calendarSnapshot = await FirebaseFirestore.instance
        .collection("SalonCalendar")
        .doc(uid)
        .get();
    final calendarData = calendarSnapshot.data();
    Map<String, dynamic> dailySchedule = {};
    if (calendarData != null) {
      dailySchedule = calendarData['dailySchedule'];
    }
    final schedule = Schedule(dailySchedule: dailySchedule);
    return schedule;
  }

  Future<void> saveSchedule(uid, Schedule schedule) async {
    final calendar = {"dailySchedule": schedule.asMap()};
    await FirebaseFirestore.instance
        .collection("SalonCalendar")
        .doc(uid)
        .set(calendar);
  }
}
