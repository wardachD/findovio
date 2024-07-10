import 'package:findovio/models/salon_schedule.dart';

String timeWithoutSeconds(SalonSchedule userAppointment) {
  String result =
      '${userAppointment.timeFrom.split(':')[0]}:${userAppointment.timeFrom.split(':')[1]} ';
  return result;
}
