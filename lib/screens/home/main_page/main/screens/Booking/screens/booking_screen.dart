import 'package:findovio/consts.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/models/salon_schedule.dart';
import 'package:findovio/models/salon_working_hours.dart';
import 'package:findovio/screens/home/main_page/main/screens/Booking/screens/booking_schedule.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'widgets/title_bar_with_back_button.dart';

class BookingScreen extends StatefulWidget {
  final SalonModel salon;
  final List<Services> services;
  final Future<List<SalonSchedule>> schedule;
  final Future<List<SalonWorkingHours>> workingHours;

  const BookingScreen(
      {super.key,
      required this.salon,
      required this.services,
      required this.schedule,
      required this.workingHours});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int totalDuration = 0;
  num totalPrice = 0;
  int timeslotsNeeded = 0;

  @override
  void initState() {
    computeDurationAndPrice();
    super.initState();
  }

  @override
  void dispose() {
    totalDuration = 0;
    timeslotsNeeded = 0;
    super.dispose();
  }

  void computeDurationAndPrice() {
    totalDuration = 0;
    totalPrice = 0;
    for (var service in widget.services) {
      totalDuration += service.durationMinutes;
      totalPrice += num.parse(service.price);
    }
    // Fetch the working hours to determine the timeslot length
    widget.workingHours.then((List<SalonWorkingHours> workingHoursList) {
      if (workingHoursList.isNotEmpty) {
        final timeslotLength = workingHoursList[0].timeSlotLength;
        setState(() {
          timeslotsNeeded = (totalDuration + timeslotLength - 1) ~/
              timeslotLength; // Rounded up division
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TitleBarWithBackButton(
                  title: 'potwierdź usługi',
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                    itemCount: widget.services.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        shadowColor: const Color.fromARGB(255, 112, 112, 112),
                        child: ListTile(
                            title: Text(
                              widget.services[index].title,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 32, 32, 32),
                                  fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              widget.services[index].description,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 32, 32, 32),
                                  fontWeight: FontWeight.w500),
                            ),
                            trailing: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25)),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.orange,
                                                offset: Offset(0, 1),
                                                blurRadius: 0.5,
                                              )
                                            ]),
                                        child: Icon(MdiIcons.minus)),
                                    onTap: () {
                                      setState(() {
                                        widget.services.removeAt(index);
                                        computeDurationAndPrice();
                                      });
                                    },
                                  ),
                                  Text('${widget.services[index].price} zł',
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 32, 32, 32),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13))
                                ])),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        height: MediaQuery.sizeOf(context).height * 0.15,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(52, 0, 0, 0),
                blurRadius: 12.0,
                offset: Offset(0, 3)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Razem',
                      style: TextStyle(
                          color: Color.fromARGB(255, 32, 32, 32),
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'W tym 23% vat',
                      style: TextStyle(
                          color: Color.fromARGB(255, 26, 26, 26),
                          fontWeight: FontWeight.w300,
                          fontSize: 14),
                    ),
                  ],
                ),
                Text(
                  '${totalPrice.toString()} PLN',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 32, 32, 32),
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            ConstsWidgets.gapH8,
            GestureDetector(
              onTap: () {
                Get.to(() => BookingSchedule(
                    salon: widget.salon,
                    services: widget.services,
                    schedule: widget.schedule,
                    workingHours: widget.workingHours,
                    duration: totalDuration,
                    price: totalPrice,
                    amountOfTimeslots: timeslotsNeeded));
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.sizeOf(context).width,
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Zarezerwuj     ',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    Icon(MdiIcons.arrowRight, color: Colors.white, size: 18)
                  ],
                ),
              ),
            ),
            const SizedBox()
          ],
        ),
      ),
    );
  }
}
