import 'package:findovio/consts.dart';
import 'package:findovio/controllers/user_data_provider.dart';
import 'package:findovio/models/user_appointment.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:findovio/widgets/title_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'widgets/upcoming_appointments_list.dart';

class AppointmentsScreen extends StatefulWidget {
  final bool? isBridgeNavigation; // Optional boolean variable

  const AppointmentsScreen({super.key, this.isBridgeNavigation});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  Future<List<UserAppointment>>? appointmentDataFromRequest;
  void _manuallyUpdate() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  Future<List<UserAppointment>> fetchData(User user) async {
    return fetchAppointments(http.Client(), user.uid);
  }

  @override
  Widget build(BuildContext context) {
    final userD = Provider.of<UserDataProvider>(context, listen: false);
    userD.refreshUser();
    if (userD.user != null) {
      appointmentDataFromRequest = fetchData(userD.user!);
    }
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 15.0),
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      child: Stack(children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          clipBehavior: Clip.none,
                          width: MediaQuery.sizeOf(context).width * 0.2,
                          height: 13, // Adjust the height of the line as needed
                          color: Colors.orange,
                        ),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleBar(text: "umówione wizyty"),
                            Icon(Icons.calendar_today),
                          ],
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              TabBar(
                indicatorColor: Colors.orange,
                labelColor: Colors.black,
                controller: _tabController,
                unselectedLabelStyle: const TextStyle(color: Colors.black),
                labelStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: "Przyszłe"),
                  Tab(text: "Skończone"),
                  Tab(text: "Anulowane"),
                ],
              ),
              ConstsWidgets.gapH8,
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    UpcomingAppointmentsList(
                        widget: widget,
                        appointmentDataFromRequest: appointmentDataFromRequest,
                        statusToShow: AppointmentStatus.confirmed,
                        callback: _manuallyUpdate),
                    UpcomingAppointmentsList(
                        widget: widget,
                        appointmentDataFromRequest: appointmentDataFromRequest,
                        statusToShow: AppointmentStatus.finished,
                        callback: _manuallyUpdate),
                    UpcomingAppointmentsList(
                        widget: widget,
                        appointmentDataFromRequest: appointmentDataFromRequest,
                        statusToShow: AppointmentStatus.cancelled,
                        callback: _manuallyUpdate),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
