import 'package:findovio/models/user_appointment.dart';
import 'package:flutter/material.dart';

class AppointmentsProvider extends ChangeNotifier {
  List<UserAppointment>? _appointments;

  List<UserAppointment>? get appointments => _appointments;

  void setAppointments(List<UserAppointment> appointments) {
    _appointments = appointments;
    notifyListeners();
  }
}
