import 'package:findovio/screens/home/appointments/widgets/appointments_tile.dart';
import 'package:findovio/screens/home/appointments/widgets/status_box.dart';
import 'package:flutter/material.dart';

class topOfAppointmentTileWithDateAndStatus extends StatelessWidget {
  const topOfAppointmentTileWithDateAndStatus({
    super.key,
    required this.widget,
    required this.formattedDate,
  });

  final AppointmentTile widget;
  final String? formattedDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Termin: $formattedDate, ${widget.userAppointment.getFormattedFirstTimeSlot()}',
                style: const TextStyle(),
              ),
            ],
          ),
          StatusContainer(
            status: widget.userAppointment.status,
          ),
        ],
      ),
    );
  }
}
