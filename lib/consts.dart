import 'package:flutter/material.dart';

abstract class Consts {
  // Global Adress
  static const dbApi = 'https://api.findovio.nl';

  // SALON
  static const dbApiGetAll = 'https://api.findovio.nl/api/salons/?format=json';
  static const dbApiGetOne = 'https://api.findovio.nl/api/salons/';
  static const dbApiSearch = 'https://api.findovio.nl/api/search/?';

  // SALON BOOKING
  static const dbApiPostBooking = 'https://api.findovio.nl/api/appointments/';
  static const dbApiGetUserBookings =
      'https://api.findovio.nl/api/user-appointments/?format=json&user_id=';

  // SALON SERVICES
  static const dbApiGetSalonService = 'https://api.findovio.nl/api/services/';

  // USER
  static const dbApiRegisterFirebaseUser =
      'https://api.findovio.nl/api/frb-users/';
  static const dbApiChangeFirebaseUser =
      'https://api.findovio.nl/api/frb-users/';
  static const dbApiGetFirebaseUserByUid =
      'https://api.findovio.nl/api/firebase-users/id/';

  // KEYWORDS-CITIES
  static const dbApiGetKeywordsList = 'https://api.findovio.nl/api/keywords/';
  static const dbApiGetCitiesList = 'https://api.findovio.nl/api/get-cities/';

  // ADS
  static const dbApiGetAllAdvertisements =
      'https://api.findovio.nl/api/all-advertisements/';
  static const dbApiGetFindovioAdvertisement =
      'https://api.findovio.nl/api/findovioadvertisements/2/';
  static String dbApiSendStatusChange(
      int appointmentId, String appointmentStatus) {
    return 'https://api.findovio.nl/api/appointments/${appointmentId.toString()}/update_status/?status=${appointmentStatus.toString()}';
  }

  // REVIEW
  static const dbApiPostReview = 'https://api.findovio.nl/api/reviews/';
  static const dbApiGetReviews = 'https://api.findovio.nl/api/salons/';
}

abstract class ConstsWidgets {
  static const gapW4 = SizedBox(width: 4.0);
  static const gapW8 = SizedBox(width: 8.0);
  static const gapW12 = SizedBox(width: 12.0);
  static const gapW16 = SizedBox(width: 16.0);
  static const gapW20 = SizedBox(width: 20.0);

  static const gapH4 = SizedBox(height: 4.0);
  static const gapH8 = SizedBox(height: 8.0);
  static const gapH12 = SizedBox(height: 12.0);
  static const gapH16 = SizedBox(height: 16.0);
  static const gapH20 = SizedBox(height: 20.0);
}

abstract class AppointmentStatus {
  static const String finished = 'F';
  static const String cancelled = 'X';
  static const String confirmed = 'C';
  static const String pending = 'P';
}

abstract class AppColors {
  static const Color lightColorTextField = Color.fromARGB(255, 243, 243, 243);
  static const Color backgroundColor = Colors.white;
  static const Color accentColor = Color.fromARGB(255, 241, 142, 49);
  static const Color primaryColorText = Color.fromARGB(255, 8, 8, 8);
  static const Color primaryLightColorText = Color.fromARGB(255, 56, 56, 56);
  static const Color redLigthError = Color.fromARGB(255, 250, 135, 135);
  static const Color barrierColor = Color.fromARGB(78, 0, 0, 0);
}

abstract class AppMargins {
  static const EdgeInsets defaultMargin = EdgeInsets.fromLTRB(20, 0, 20, 0);
}
