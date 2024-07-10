import 'package:flutter/material.dart';

class DayFromCalendar extends StatelessWidget {
  const DayFromCalendar({
    super.key,
    required this.itemWidth,
    required this.isCurrentDateSelected,
    required this.hasTimeSlots,
    required this.day,
    required this.weekday,
  });

  final double itemWidth;
  final bool isCurrentDateSelected;
  final bool hasTimeSlots;
  final String day;
  final String weekday;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: itemWidth,
      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(
          color: isCurrentDateSelected
              ? Colors.orange // Border color when selected
              : hasTimeSlots
                  ? const Color.fromARGB(255, 255, 168,
                      87) // Transparent border when has time slots
                  : const Color.fromARGB(
                      255, 255, 255, 255), // Border color when no time slots
        ),
        color: isCurrentDateSelected
            ? Colors.orange
            : hasTimeSlots
                ? const Color.fromARGB(255, 255, 255, 255)
                : const Color.fromARGB(255, 247, 247,
                    247), // <-- Zmieniamy tło w zależności od wyboru
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: isCurrentDateSelected
                  ? Colors.white // Font color when selected
                  : hasTimeSlots
                      ? Colors.black
                      : const Color.fromARGB(255, 204, 204, 204),
            ),
          ),
          Text(
            weekday,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: isCurrentDateSelected
                  ? Colors.white // Font color when selected
                  : hasTimeSlots
                      ? Colors.black
                      : const Color.fromARGB(255, 204, 204, 204),
            ),
          ),
        ],
      ),
    );
  }
}
