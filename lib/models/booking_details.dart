import 'package:findovio/models/salon_model.dart';
import 'package:findovio/models/salon_schedule.dart';

class BookingDetails {
  final SalonModel? salonInfo;
  final Services? servicesInfo;
  final SalonSchedule? scheduleInfo;

  BookingDetails(this.salonInfo, this.servicesInfo, this.scheduleInfo);
}
