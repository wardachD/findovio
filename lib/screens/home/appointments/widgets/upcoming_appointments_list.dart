import 'package:findovio/consts.dart';
import 'package:findovio/screens/home/appointments/widgets/appointment_tile_placeholder.dart';
import 'package:findovio/screens/home/appointments/widgets/hidable_advertisements.dart';
import 'package:flutter/material.dart';
import 'package:findovio/models/user_appointment.dart';
import 'package:findovio/screens/home/appointments/appointments_screen.dart';
import 'package:findovio/screens/home/appointments/widgets/appointments_tile.dart';

class UpcomingAppointmentsList extends StatefulWidget {
  final AppointmentsScreen widget;
  final String statusToShow;
  final Future<List<UserAppointment>>? appointmentDataFromRequest;
  final VoidCallback callback;

  const UpcomingAppointmentsList({
    super.key,
    required this.widget,
    required this.appointmentDataFromRequest,
    required this.statusToShow,
    required this.callback,
  });

  @override
  State<UpcomingAppointmentsList> createState() =>
      _UpcomingAppointmentsListState();
}

class _UpcomingAppointmentsListState extends State<UpcomingAppointmentsList> {
  late List<UserAppointment> filteredAppointments;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserAppointment>>(
      future: widget.appointmentDataFromRequest,
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: _buildContent(snapshot),
        );
      },
    );
  }

  Widget _buildContent(AsyncSnapshot<List<UserAppointment>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return _buildLoadingWidget();
    } else if (snapshot.hasError) {
      return _buildErrorWidget(snapshot.hasError);
    } else if (snapshot.hasData) {
      return _buildDataWidget(snapshot.data!);
    } else {
      return _buildDefaultWidget();
    }
  }

  Widget _buildLoadingWidget() {
    return const Column(
      children: [
        SizedBox(
          height: 292, // Adjust the height as needed
          child: AppointmentTilePlaceholder(),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(Object error) {
    return Text('Błąd: $error');
  }

  Widget _buildDataWidget(List<UserAppointment> data) {
    List<UserAppointment> filteredAppointments;
    // Filter appointments based on status
    if (widget.statusToShow == AppointmentStatus.confirmed ||
        widget.statusToShow == AppointmentStatus.pending) {
      filteredAppointments = data
          .where((appointment) =>
              appointment.status == AppointmentStatus.confirmed ||
              appointment.status == AppointmentStatus.pending)
          .toList();
    } else if (widget.statusToShow == AppointmentStatus.finished) {
      filteredAppointments = data
          .where(
              (appointment) => appointment.status == AppointmentStatus.finished)
          .toList();
    } else {
      filteredAppointments = data
          .where((appointment) => appointment.status == widget.statusToShow)
          .toList();
    }

    if (filteredAppointments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.zero,
        child: HidableColumnWidget(),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        // I want to see the nearest schedule first
        itemCount: filteredAppointments.length,
        itemBuilder: (context, index) {
          final appointment = filteredAppointments[index];
          return AppointmentTile(
            userAppointment: appointment,
            callback: widget.callback,
          );
        },
      ),
    );
  }

  Widget _buildDefaultWidget() {
    return const Padding(
      padding: EdgeInsets.zero,
      child: HidableColumnWidget(),
    );
  }
}
