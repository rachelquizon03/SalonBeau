import 'package:salon_app/data/schedule_repository.dart';
import 'package:salon_app/data/service_repository.dart';
import 'package:salon_app/data/stylist_repository.dart';

Future<bool> isSalonReady(salonId) async {
  final services = await ServiceRepository().getServicesByUid(salonId);
  final stylists = await StylistRepository().getStylistsByUid(salonId);
  final schedule = await ScheduleRepository().getScheduleByUid(salonId);
  return services.isNotEmpty &&
      stylists.isNotEmpty &&
      schedule.blocks.isNotEmpty;
}
