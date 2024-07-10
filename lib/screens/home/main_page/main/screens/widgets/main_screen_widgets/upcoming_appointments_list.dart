import 'package:findovio/models/user_appointment.dart';
import 'package:flutter/material.dart';
import 'booking_card.dart';

class UpcomingAppointmentsList extends StatefulWidget {
  final List<UserAppointment> appointments;

  const UpcomingAppointmentsList({Key? key, required this.appointments})
      : super(key: key);

  @override
  State<UpcomingAppointmentsList> createState() =>
      _UpcomingAppointmentsListState();
}

class _UpcomingAppointmentsListState extends State<UpcomingAppointmentsList> {
  late List<UserAppointment> filteredAppointments;

  @override
  void initState() {
    super.initState();
    filteredAppointments = widget.appointments
        .where((appointment) =>
            appointment.status == "C" || appointment.status == "P")
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(25, 0, 0, 8),
            child: Text(
              'Rezerwacje',
              textAlign: TextAlign.start,
              style: TextStyle(
                  letterSpacing: 0.1,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color.fromARGB(255, 22, 22, 22)),
            ),
          ),
        ),
        Container(
          width: double.infinity, // Adjust the width as needed
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(filteredAppointments.length, (index) {
                return BookingCard(
                  appointment: filteredAppointments[index],
                  amountOfAppointments: filteredAppointments.length,
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
