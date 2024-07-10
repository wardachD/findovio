import 'package:flutter/material.dart';

class StatusContainer extends StatelessWidget {
  final String status;

  const StatusContainer({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: status == 'C'
              ? Colors.greenAccent
              : status == 'P'
                  ? Colors.orangeAccent
                  : status == 'F'
                      ? Colors.grey
                      : Colors.redAccent),
      child: Text(
        status == 'C'
            ? 'Potwierdzone'
            : status == 'P'
                ? 'Oczekiwanie'
                : status == 'F'
                    ? 'Zakończone'
                    : 'Anulowane',
        style: const TextStyle(
            fontWeight: FontWeight.w800, fontSize: 11, color: Colors.white),
      ),
    );
  }
}
