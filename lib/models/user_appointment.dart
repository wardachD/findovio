import 'package:findovio/models/salon_schedule.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'salon_model.dart';

class UserAppointment {
  final int id;
  final int salon;
  final String salonName;
  final String customer;
  final String dateOfBooking;
  final List<Services> services;
  final String totalAmount;
  final String comment;
  final String status;
  final String createdAt;
  final List<SalonSchedule> timeslots;

  UserAppointment({
    required this.id,
    required this.salon,
    required this.salonName,
    required this.customer,
    required this.dateOfBooking,
    required this.services,
    required this.totalAmount,
    required this.comment,
    required this.status,
    required this.createdAt,
    required this.timeslots,
  });

  factory UserAppointment.fromJson(Map<String, dynamic> json) {
    return UserAppointment(
      id: json['id'],
      salon: json['salon'],
      salonName: json['salon_name'],
      customer: json['customer'],
      dateOfBooking: json['date_of_booking'],
      services: List<Services>.from(
          json['services'].map((service) => Services.fromJson(service))),
      totalAmount: json['total_amount'],
      comment: json['comment'],
      status: json['status'],
      createdAt: json['created_at'],
      timeslots: List<SalonSchedule>.from(json['timeslots']
          .map((timeslots) => SalonSchedule.fromJson(timeslots))),
    );
  }

  String? getFormattedDateOfBooking() {
    try {
      // Initialize locale data before formatting the date
      initializeDateFormatting('pl_PL', null);

      // Parse the date string to a DateTime object
      DateTime date = DateTime.parse(dateOfBooking);

      // Format the DateTime object to the desired format
      String formattedDate = DateFormat('d MMMM', 'pl_PL').format(date);

      return formattedDate.capitalizeFirst;
    } catch (e) {
      // Handle error if locale initialization fails
      print('Error initializing locale data: $e');
      // Return a default value or handle the case when the date is not formatted yet
      return ''; // Return an empty string or default value for now
    }
  }

  String getFormattedFirstTimeSlot() {
    // Parsuj ciąg czasu do obiektu DateTime
    DateTime time = DateFormat('HH:mm:ss').parse(timeslots[0].timeFrom);

    // Formatuj obiekt DateTime do pożądanego formatu (bez sekund)
    String formattedTime = DateFormat('H:mm').format(time);

    return formattedTime;
  }
}

List<UserAppointment> parseAppointmentsList(List<dynamic> jsonList) {
  return jsonList.map((json) => UserAppointment.fromJson(json)).toList();
}
