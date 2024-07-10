import 'package:findovio/models/firebase_py_get_model.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/models/user_appointment.dart'; // Import UserAppointment model
import 'package:findovio/providers/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FirebasePyUserProvider extends ChangeNotifier {
  FirebasePyGetModel? _user;
  String? _userUid;

  List<SalonModel>? _salons;
  List<UserAppointment>? _appointments; // Add a property for appointments
  bool _hideMe = false;

  FirebasePyGetModel? get user => _user;
  List<SalonModel>? get salons => _salons;
  List<UserAppointment>? get appointments => _appointments;
  bool get hideMe => _hideMe;

  void setHideMe(bool value) {
    _hideMe = value;
    notifyListeners(); // Notify listeners after updating the property
  }

  void setHideMeWithoutNotification(bool value) {
    _hideMe = value; // Notify listeners after updating the property
  }

  void setUserUid(String uid) {
    _userUid = uid;
  }

  Future<int> changeUserName(String newUserName, String userUid) async {
    if (_userUid == null) {
      return Future.value(0);
    }

    try {
      await changeFirebasePyUser(http.Client(), newUserName, _userUid!);

      notifyListeners();
      return Future.value(200);
    } catch (e) {
      print('Error fetching data: $e');
      return Future.value(-1);
    }
  }

  Future<void> fetchData() async {
    if (_userUid == null) {
      return;
    }

    try {
      try {
        final user = await fetchFirebasePyUser(http.Client(), _userUid!);

        _user = user;
      } catch (e) {
        print('Error fetching FireBasePy user: $e');
      }
      try {
        final salons = await fetchSalons(http.Client());

        _salons = salons;
      } catch (e) {
        print('Error fetching fetchSalons: $e');
      }
      try {
        final appointments = await fetchAppointments(http.Client(), _userUid!);
        _appointments = appointments; // Fetch appointments
      } catch (e) {
        print('Error fetching fetchAppointments: $e');
      }
      // Set appointments data

      notifyListeners();
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> fetchDataWithoutUpdate() async {
    if (_userUid == null) {
      return;
    }

    try {
      try {
        final user = await fetchFirebasePyUser(http.Client(), _userUid!);
      } catch (e) {
        print('Error fetching FireBasePy user: $e');
      }
      try {
        final salons = await fetchSalons(http.Client());
      } catch (e) {
        print('Error fetching fetchSalons: $e');
      }
      try {
        final appointments = await fetchAppointments(
            http.Client(), _userUid!); // Fetch appointments
      } catch (e) {
        print('Error fetching fetchAppointments: $e');
      } // Fetch appointments

      _user = user;
      _salons = salons;
      _appointments = appointments; // Set appointments data
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void clearData() {
    _user = null;
    _userUid = null;
    _salons = null;
    _appointments = null;

    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  void updateWithFetch() {
    fetchData();
    notifyListeners();
  }
}
