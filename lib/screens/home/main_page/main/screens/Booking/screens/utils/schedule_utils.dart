import 'package:findovio/models/salon_schedule.dart';
import 'package:flutter/material.dart';

void resetScrollPosition(
    ScrollController scrollController, VoidCallback updateState) {
  Future.delayed(Duration.zero, () {
    updateState();
    scrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  });
}

DateTime normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

List<SalonSchedule> filterAvailableTimeSlots(
    List<SalonSchedule> schedules, int requiredSlots) {
  List<SalonSchedule> availableSlots = [];
  for (int i = 0; i <= schedules.length - requiredSlots; i++) {
    bool isConsecutive = true;
    for (int j = 0; j < requiredSlots - 1; j++) {
      if (schedules[i + j].date != schedules[i + j + 1].date ||
          !schedules[i + j].isAvailable ||
          !schedules[i + j + 1].isAvailable) {
        isConsecutive = false;
        break;
      }
    }
    if (isConsecutive) {
      availableSlots.add(schedules[i]);
    }
  }
  return availableSlots;
}

Map<DateTime, List<SalonSchedule>> mapTimeSlotsToDays(
    List<SalonSchedule> schedules) {
  Map<DateTime, List<SalonSchedule>> dayToTimeSlots = {};
  for (var schedule in schedules) {
    DateTime scheduleDate = normalizeDate(DateTime.parse(schedule.date));
    if (!dayToTimeSlots.containsKey(scheduleDate)) {
      dayToTimeSlots[scheduleDate] = [];
    }
    dayToTimeSlots[scheduleDate]!.add(schedule);
  }
  return dayToTimeSlots;
}

String formatTime(String timeFrom) {
  final timeParts = timeFrom.split(':');
  if (timeParts.length < 2) {
    return timeFrom; // Return original string if it doesn't at least have hours and minutes
  }

  final hour = int.parse(timeParts[0]);
  final minute = int.parse(timeParts[1]);

  final timeOfDay = TimeOfDay(hour: hour, minute: minute);
  return '${timeOfDay.hour}:${timeOfDay.minute.toString().padLeft(2, '0')}'; // Format to HH:mm
}
