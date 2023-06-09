import 'package:intl/intl.dart';

class Schedule {
  Schedule({required this.dailySchedule}) {
    initBlocks();
  }

  final Map<String, dynamic> dailySchedule;

  // for UI simplicity
  List<ScheduleBlock> _blocks = [];
  List<ScheduleBlock> get blocks => _blocks;

  void initBlocks() {
    final List<ScheduleBlock> blocks = [];
    dailySchedule.forEach((k, v) {
      final times = v.toString().split('-').map((e) => e.trim()).toList();
      final startTime = DateFormat.jm().parse(times.first);
      final endTime = DateFormat.jm().parse(times.last);
      blocks.add(ScheduleBlock(day: k, startTime: startTime, endTime: endTime));
    });
    _blocks = blocks;
  }

  void addBlock(ScheduleBlock block) {
    _blocks.add(block);
  }

  void removeBlock(ScheduleBlock block) {
    _blocks = _blocks.where((x) => x.day != block.day).toList();
  }

  Map<String, dynamic> asMap() {
    final Map<String, dynamic> data = {};
    for (final block in _blocks) {
      data[block.day] = "${DateFormat.jm().format(block.startTime)} - ${DateFormat.jm().format(block.endTime)}";
    }
    return data;
  }
}

class ScheduleBlock {
  ScheduleBlock({
    required this.day,
    required this.startTime,
    required this.endTime,
  });
  final String day;
  DateTime startTime;
  DateTime endTime;
}
