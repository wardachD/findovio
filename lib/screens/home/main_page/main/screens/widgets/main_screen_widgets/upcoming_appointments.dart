import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'upcoming_appointments_list.dart';
import 'package:findovio/providers/firebase_py_user_provider.dart';

class UpcomingAppointments extends StatefulWidget {
  final String userId;

  const UpcomingAppointments({super.key, required this.userId});

  @override
  State<UpcomingAppointments> createState() => _UpcomingAppointmentsState();
}

class _UpcomingAppointmentsState extends State<UpcomingAppointments> {
  bool _isLoading = true;
  double height = 120;

  @override
  void initState() {
    super.initState();
    // Start loading data after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_isLoading) {
        height = MediaQuery.sizeOf(context).height * 0.16;
      }
      if (mounted) {
        Provider.of<FirebasePyUserProvider>(context, listen: false)
            .fetchDataWithoutUpdate()
            .then((_) {
          // Once data is loaded, update the state to stop showing the loading indicator
          if (mounted) {
            setState(() {
              _isLoading = false;
              // List<UserAppointment>? temp =
              //     Provider.of<FirebasePyUserProvider>(context, listen: false)
              //         .appointments;
              // if (temp != null) {
              //   if (temp.every((element) => element.status == 'X') ||
              //       temp.isEmpty) {
              //     height = 0;
              //   } else {
              //     height = 0;
              //   }
              // } else {
              //   height = MediaQuery.sizeOf(context).height * 0.16;
              // }
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: Consumer<FirebasePyUserProvider>(
              key: const ValueKey<int>(1),
              builder: (context, provider, child) {
                final appointments = provider.appointments;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  height: (appointments == List.empty() || appointments == null)
                      ? 0
                      : appointments.every((element) => element.status == 'X')
                          ? 0
                          : MediaQuery.sizeOf(context).height * 0.24,
                  child: appointments == List.empty() || appointments == null
                      ? const SizedBox() // No upcoming appointments
                      : appointments.every((element) => element.status == 'X')
                          ? const SizedBox()
                          : UpcomingAppointmentsList(
                              key: const ValueKey<int>(2),
                              appointments: appointments),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
