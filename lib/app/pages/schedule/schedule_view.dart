import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salon_app/app/pages/salon_dashboard/salon_dashboard_view.dart';
import 'package:salon_app/app/pages/services/services_add_view.dart';
import 'package:salon_app/app/widgets/dialog.dart';
import 'package:salon_app/data/salon_repository.dart';
import 'package:salon_app/data/schedule_repository.dart';
import 'package:salon_app/domain/entities/schedule.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  Schedule? _schedule;

  void loadSchedule() async {
    final schedule =
        await ScheduleRepository().getScheduleByUid(SalonRepository.salon!.id);
    setState(() {
      _schedule = schedule;
    });
  }

  @override
  void initState() {
    loadSchedule();
    super.initState();
  }

  void handleBack() {
    Navigator.of(context).pop();
  }

  void handleSave() async {
    if (_schedule == null) return;

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
                Text('Saving schedule'),
              ],
            ),
          ),
        );
      },
    );

    try {
      await ScheduleRepository()
          .saveSchedule(SalonRepository.salon!.id, _schedule!);
      Navigator.of(context).pop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SalonDashboardView(),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
    }
  }

  void handleStart(block) async {
    final initialTime = TimeOfDay.fromDateTime(block.startTime);
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (selectedTime != null) {
      final DateTime existingTime = block.startTime;
      final DateTime startTime = DateTime(
        existingTime.year,
        existingTime.month,
        existingTime.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      setState(() {
        block.startTime = startTime;
      });
    }
  }

  void handleEnd(block) async {
    final initialTime = TimeOfDay.fromDateTime(block.endTime);
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (selectedTime != null) {
      final DateTime existingTime = block.endTime;
      final DateTime endTime = DateTime(
        existingTime.year,
        existingTime.month,
        existingTime.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      setState(() {
        block.endTime = endTime;
      });
    }
  }

  void handleSchedule() async {
    final scheduleBlock = await showScheduleDialog(context);
    if (scheduleBlock != null) {
      final existingSchedule = _schedule!.blocks
          .where((block) => block.day == scheduleBlock.day)
          .toList();
      if (existingSchedule.isNotEmpty) {
        showOkDialog(
          context: context,
          titleText: 'Unable to add schedule',
          contentText: 'Schedule already exists!',
        );
        return;
      }
      setState(() {
        _schedule!.addBlock(scheduleBlock);
      });
    }
  }

  void handleRemove(block) {
    showAlertDialog(
      context: context,
      titleText: 'Delete Schedule',
      contentText: 'Are you sure you would like to delete this schedule block?',
      onContinue: () {
        Navigator.of(context).pop();
        setState(() {
          _schedule!.removeBlock(block);
        });
      },
    );
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
              padding: const EdgeInsets.symmetric(
                vertical: 25.0,
                horizontal: 15.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            'Schedule',
                            style: TextStyle(
                              color: Color(0xFFC93480),
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: handleSave,
                        icon: const Icon(
                          Icons.save,
                          color: Color(0xFFC93480),
                          size: 28.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  if (_schedule != null)
                    ..._schedule!.blocks
                        .map(
                          (block) => ScheduleRow(
                            block: block,
                            handleStart: handleStart,
                            handleEnd: handleEnd,
                            handleRemove: handleRemove,
                          ),
                        )
                        .toList(),
                  TextButton.icon(
                    onPressed: handleSchedule,
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Color(0xFFC93480),
                    ),
                    label: const Text(
                      'Add Schedule',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Color(0xFFC93480),
                      ),
                    ),
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

class ScheduleRow extends StatelessWidget {
  const ScheduleRow({
    super.key,
    required this.block,
    this.handleStart,
    this.handleEnd,
    this.handleRemove,
  });

  final ScheduleBlock block;

  final void Function(ScheduleBlock)? handleStart;
  final void Function(ScheduleBlock)? handleEnd;
  final void Function(ScheduleBlock)? handleRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Container(
        padding: const EdgeInsets.only(
          left: 25.0,
          top: 15.0,
          right: 25.0,
          bottom: 15.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  block.day,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                IconButton(
                  onPressed: () => handleRemove?.call(block),
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Start Time',
                  style: TextStyle(color: Colors.black54),
                ),
                TextButton(
                  onPressed: () => handleStart?.call(block),
                  child: Text(DateFormat.jm().format(block.startTime)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'End Time',
                  style: TextStyle(color: Colors.black54),
                ),
                TextButton(
                  onPressed: () => handleEnd?.call(block),
                  child: Text(DateFormat.jm().format(block.endTime)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
