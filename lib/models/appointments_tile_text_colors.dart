import 'package:findovio/consts.dart';
import 'package:flutter/material.dart';

String getStatusText(String status) {
  switch (status) {
    case AppointmentStatus.confirmed:
      return "Confirmed";
    case AppointmentStatus.pending:
      return "Pending";
    case AppointmentStatus.cancelled:
      return "Canceled";
    case AppointmentStatus.finished:
      return "Finished";
    default:
      return "Unknown"; // Handle other statuses if needed
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case AppointmentStatus.confirmed:
      return Colors.green;
    case AppointmentStatus.pending:
      return Colors.orange;
    case AppointmentStatus.cancelled:
      return Colors.red;
    case AppointmentStatus.finished:
      return Colors.green;
    default:
      return Colors.black; // Default color for unknown statuses
  }
}
