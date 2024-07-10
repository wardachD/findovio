import 'package:findovio/models/user_appointment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectedAppointmentScreen extends StatelessWidget {
  final UserAppointment? appointmentData;

  const SelectedAppointmentScreen({Key? key, required this.appointmentData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Go back to Appointments'),
            ),
            Text('Salon Name: ${appointmentData!.salonName}'),
            Text('Customer: ${appointmentData!.salonName}'),
            Text('Date of Booking: ${appointmentData!.salonName}'),
            Text('Total Amount: ${appointmentData!.salonName}'),
            Text('Comment: ${appointmentData!.salonName}'),
            Text('Status: ${appointmentData!.salonName}'),
            Text('Created At: ${appointmentData!.salonName}'),
            const Text('Services:'),
            ListView.builder(
              shrinkWrap: true,
              itemCount: appointmentData!.services.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title:
                      Text('Title: ${appointmentData!.services[index].title}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Description: ${appointmentData!.services[index].description}'),
                    ],
                  ),
                );
              },
            ),
            const Text('Timeslots:'),
            ListView.builder(
              shrinkWrap: true,
              itemCount: appointmentData!.timeslots.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      'Time From: ${appointmentData!.timeslots[index].timeFrom}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Time To: ${appointmentData!.timeslots[index].timeTo}'),
                      Text(
                          'Available: ${appointmentData!.timeslots[index].isAvailable}'),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
