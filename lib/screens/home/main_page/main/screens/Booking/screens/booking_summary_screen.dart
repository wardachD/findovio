import 'package:findovio/consts.dart';
import 'package:findovio/controllers/user_data_provider.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/models/salon_schedule.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'booking_confirmation_screen.dart';
import 'widgets/title_bar_with_back_button.dart';

class BookingSummaryScreen extends StatefulWidget {
  final SalonModel salon;
  final List<Services> services;
  final DateTime selectedDate;
  final List<SalonSchedule> selectedTimeSlots;
  final num price;
  final int duration;

  const BookingSummaryScreen({
    super.key,
    required this.salon,
    required this.selectedDate,
    required this.selectedTimeSlots,
    required this.services,
    required this.price,
    required this.duration,
  });

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen>
    with WidgetsBindingObserver {
  String userComment = '';
  bool termsAccepted = false;
  bool isBookingInProgress = false;
  bool isSuccess = false;
  UserDataProvider user = UserDataProvider();

  @override
  void initState() {
    super.initState();
    // Add this widget as an observer to listen for keyboard visibility changes
    WidgetsBinding.instance.addObserver(this);
    user.refreshUser();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    user.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List bookingServicesID =
        widget.services.map((service) => service.id).toList();
    List bookingSelectedTimeSlotsID =
        widget.selectedTimeSlots.map((timeSlot) => timeSlot.id).toList();
    final Map<String, dynamic> data = {
      "salon": widget.salon.id,
      "customer": user.user?.uid,
      "services": bookingServicesID,
      "comment": userComment,
      "timeslots": bookingSelectedTimeSlotsID,
    };
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TitleBarWithBackButton(
                    title: 'Potwierdzenie',
                  ),
                ),
                ConstsWidgets.gapH16,
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color.fromARGB(255, 235, 235, 235),
                        width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Informacje o rezerwacji',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Salon/barber',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            widget.salon.name,
                            style: const TextStyle(
                              fontWeight: FontWeight
                                  .w600, // Waga dla elementów po prawej
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Miasto',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            widget.salon.addressCity,
                            style: const TextStyle(
                              fontWeight: FontWeight
                                  .w600, // Waga dla elementów po prawej
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Ulica',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${widget.salon.addressStreet}, ${widget.salon.addressNumber}',
                            style: const TextStyle(
                              fontWeight: FontWeight
                                  .w600, // Waga dla elementów po prawej
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Data rezerwacji',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${widget.selectedDate.year.toString()} - ${widget.selectedDate.month.toString()} - ${widget.selectedDate.day}',
                            style: const TextStyle(
                              fontWeight: FontWeight
                                  .w600, // Waga dla elementów po prawej
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Godzina rezerwacji',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            (widget.selectedTimeSlots[0].timeFrom.toString())
                                .substring(
                                    0,
                                    widget.selectedTimeSlots[0].timeFrom
                                            .toString()
                                            .length -
                                        3),
                            style: const TextStyle(
                              fontWeight: FontWeight
                                  .w600, // Waga dla elementów po prawej
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ConstsWidgets.gapH16,
                Container(
                  margin: const EdgeInsets.fromLTRB(
                      10, 12, 10, 0), // Dostosuj margines
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color.fromARGB(255, 235, 235, 235),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Zabookowane usługi',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Wyświetl listę zabookowanych usług
                      for (int index = 0;
                          index < widget.services.length;
                          index++)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.services[index].title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '${widget.services[index].price} zł',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      Container(
                        height: 0.4,
                        color: const Color.fromARGB(255, 235, 235, 235),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Razem',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            // Oblicz sumę cen usług
                            '${widget.services.map((service) => double.parse(service.price.replaceAll(',', '.'))).fold(0.0, (prev, curr) => prev + curr)} zł',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ConstsWidgets.gapH16,
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 12, 10, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color.fromARGB(255, 235, 235, 235),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Ikona banknotu (możesz dostosować ikonę)
                          Icon(MdiIcons.cash,
                              color: const Color.fromARGB(255, 54, 54, 54)),
                          const SizedBox(width: 6),
                          // Tekst "Sposób płatności"
                          const Text(
                            'Płatność',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      // Napis "Na miejscu"
                      const Text(
                        'Na miejscu',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          height: 65,
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
              GestureDetector(
                onTap: () async {
                  if (mounted) {
                    setState(() {
                      isBookingInProgress = true; // Set booking status to true
                    });
                  }

                  var bookingResult = await sendPostRequest(data);
                  if (mounted) {
                    setState(() {
                      if (bookingResult == 'success') {
                        isSuccess = true;
                        Get.to(() => BookingConfirmationScreen(
                              response: bookingResult,
                            ));
                      } else {
                        isSuccess = false;
                      }
                      Future.delayed(const Duration(seconds: 2), () async {
                        if (mounted) {
                          setState(() {
                            isBookingInProgress =
                                false; // Set booking status to true
                          });
                        }
                      });
                      // Reset booking status
                    });
                  }
                },
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                      color: isBookingInProgress
                          ? const Color.fromARGB(255, 196, 196, 196)
                          : Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange)),
                  duration: const Duration(milliseconds: 300),
                  alignment: Alignment.center,
                  width: MediaQuery.sizeOf(context).width,
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Zarezerwuj',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                      Icon(MdiIcons.arrowRight, color: Colors.white, size: 18)
                    ],
                  ),
                ),
              ),
              const SizedBox()
            ],
          ),
        ));
  }
}
