import 'package:findovio/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/models/salon_schedule.dart';
import 'package:findovio/models/salon_working_hours.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'booking_summary_screen.dart';
import 'utils/schedule_utils.dart';
import 'widgets/day_from_calendar_button.dart';
import 'widgets/title_bar_with_back_button.dart';

class BookingSchedule extends StatefulWidget {
  final SalonModel salon;
  final List<Services> services;
  final Future<List<SalonSchedule>> schedule;
  final Future<List<SalonWorkingHours>> workingHours;
  final int amountOfTimeslots;
  final num price;
  final int duration;

  const BookingSchedule({
    super.key,
    required this.salon,
    required this.services,
    required this.schedule,
    required this.workingHours,
    required this.amountOfTimeslots,
    required this.price,
    required this.duration,
  });

  @override
  State<BookingSchedule> createState() => _BookingScheduleState();
}

class _BookingScheduleState extends State<BookingSchedule> {
  final DateTime _startDate = DateTime.now();
  DateTime? selectedDate;
  List<SalonSchedule> selectedDaySlots = [];
  SalonSchedule? selectedSlot;
  final _scrollController = ScrollController();
  ScrollController _scrollControllerDays = ScrollController();
  int firstHasTimeSlotsIndex = -1;

  bool isPressed = false;

  static const int slotsPerRow = 3;

  @override
  void initState() {
    super.initState();
    selectedDate = null;
    selectedSlot = null;
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollToFirstHasTimeSlots();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToFirstHasTimeSlots() {
    if (firstHasTimeSlotsIndex != -1) {
      _scrollControllerDays.animateTo(
        firstHasTimeSlotsIndex * MediaQuery.of(context).size.height * 0.11,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget buildSlotsContainer(List<SalonSchedule> slots) {
    int numberOfRows = (slots.length / slotsPerRow).ceil();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 80,
      child: ListView.builder(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: numberOfRows,
        itemBuilder: (context, rowIndex) {
          return Row(
            children: List.generate(
              slotsPerRow,
              (columnIndex) {
                int index = rowIndex * slotsPerRow + columnIndex;
                if (index < slots.length) {
                  return buildTimeSlotButton(slots[index]);
                } else {
                  return SizedBox(width: 0); // Placeholder for empty slot
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildTimeSlotButton(SalonSchedule currentSlot) {
    bool isSelected = selectedSlot == currentSlot;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
      child: AnimatedContainer(
        height: 40,
        width: 80,
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.white,
          border: Border.all(color: const Color.fromARGB(54, 255, 128, 0)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextButton(
          onPressed: () {
            setState(() {
              selectedSlot = isSelected ? null : currentSlot;
            });
          },
          child: Text(
            formatTime(currentSlot.timeFrom),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pl_PL', null);
    double itemHeight = MediaQuery.of(context).size.height * 0.1;
    double itemWidth = MediaQuery.of(context).size.height * 0.1;

    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TitleBarWithBackButton(
                    title: 'wybierz datę i godzinę',
                  ),
                ),
                FutureBuilder<List<SalonSchedule>>(
                  future: widget.schedule,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(
                            child: Text('Wystąpił błąd: ${snapshot.error}'));
                      }
                      List<SalonSchedule> schedules = snapshot.data ?? [];

                      if (schedules.isEmpty) {
                        return const Center(
                            child: Text('Niestety brak wolnych terminów'));
                      }
                      List<SalonSchedule> availableSlots =
                          filterAvailableTimeSlots(
                              schedules, widget.amountOfTimeslots);

                      Map<DateTime, List<SalonSchedule>> dayToTimeSlots =
                          mapTimeSlotsToDays(availableSlots);

                      String lastAvailableSlot =
                          availableSlots.last.date.toString();
                      DateTime lastSlotDateTime =
                          DateTime.parse(lastAvailableSlot);
                      if (lastSlotDateTime.isBefore(DateTime.now())) {
                        return const Center(
                            child: Text('Aktualnie brak wolnych terminów'));
                      }

                      // Znajdz pierwszy dostępny slot z podaną datą i godziną
                      DateTime firstAvailableDate = _startDate;
                      while (!dayToTimeSlots
                          .containsKey(normalizeDate(firstAvailableDate))) {
                        firstAvailableDate =
                            firstAvailableDate.add(const Duration(days: 1));
                        print('CIEKNIE CI PAMIEC');
                      }

                      // Zaznacz pierwszy dzień z wolną datą dla podświetlenia przycisku
                      if (!isPressed) {
                        selectedDate = firstAvailableDate;
                      }

                      selectedDaySlots =
                          dayToTimeSlots[normalizeDate(selectedDate!)] ?? [];

                      // Separate slots into morning and afternoon
                      List<SalonSchedule> morningSlots =
                          selectedDaySlots.where((slot) {
                        final hour = int.parse(slot.timeFrom.split(':')[0]);
                        return hour < 10;
                      }).toList();

                      List<SalonSchedule> noonSlots =
                          selectedDaySlots.where((slot) {
                        final hour = int.parse(slot.timeFrom.split(':')[0]);
                        return hour >= 10 && hour < 15;
                      }).toList();

                      List<SalonSchedule> afternoonSlots =
                          selectedDaySlots.where((slot) {
                        final hour = int.parse(slot.timeFrom.split(':')[0]);
                        return hour >= 15;
                      }).toList();

                      return Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ConstsWidgets.gapH16,
                              SizedBox(
                                height: itemHeight,
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  controller: _scrollControllerDays,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 31,
                                  itemBuilder: (context, index) {
                                    DateTime currentDate =
                                        _startDate.add(Duration(days: index));
                                    bool isCurrentDateSelected =
                                        selectedDate == currentDate;
                                    String day =
                                        DateFormat('d').format(currentDate);
                                    String weekday = DateFormat('E', 'pl_PL')
                                        .format(currentDate);
                                    bool hasTimeSlots =
                                        dayToTimeSlots.containsKey(
                                            normalizeDate(currentDate));

                                    // Update the firstHasTimeSlotsIndex if it's not already found and hasTimeSlots is true
                                    if (firstHasTimeSlotsIndex == -1 &&
                                        hasTimeSlots) {
                                      firstHasTimeSlotsIndex = index;
                                    }

                                    // UPDATE THE FIRSTHASTIMESLOTS TO YOUR NEED FINDOVIODB+E[TO,ES;PTS AMD FOMDPVOPDB+IIMFOXEDP[ERATOMGHPIRS #SPATIAL_REF_SYS TRIGGER FNCTIONS TYYPES]]
                                    return InkWell(
                                      borderRadius: BorderRadius.circular(5.0),
                                      onTap: hasTimeSlots
                                          ? () {
                                              setState(() {
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  _scrollController.animateTo(
                                                      0.0,
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      curve: Curves.easeInOut);
                                                });
                                                isPressed = true;
                                                selectedSlot = null;
                                                selectedDate = currentDate;
                                                selectedDaySlots =
                                                    dayToTimeSlots[
                                                            normalizeDate(
                                                                currentDate)] ??
                                                        [];
                                              });
                                            }
                                          : null,
                                      child: DayFromCalendar(
                                        itemWidth: itemWidth,
                                        isCurrentDateSelected:
                                            isCurrentDateSelected,
                                        hasTimeSlots: hasTimeSlots,
                                        day: day,
                                        weekday: weekday,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (morningSlots.isNotEmpty) ...[
                                    ConstsWidgets.gapH20,
                                    const Padding(
                                      padding: EdgeInsets.only(left: 12.0),
                                      child: Text("Rano"),
                                    ),
                                    buildSlotsContainer(morningSlots),
                                  ],
                                  if (noonSlots.isNotEmpty) ...[
                                    ConstsWidgets.gapH20,
                                    const Padding(
                                      padding: EdgeInsets.only(left: 12.0),
                                      child: Text("Południe"),
                                    ),
                                    buildSlotsContainer(noonSlots),
                                  ],
                                  if (afternoonSlots.isNotEmpty) ...[
                                    ConstsWidgets.gapH20,
                                    const Padding(
                                      padding: EdgeInsets.only(left: 12.0),
                                      child: Text("Popołudnie"),
                                    ),
                                    buildSlotsContainer(afternoonSlots),
                                  ],
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
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
                onTap: () {
                  if (selectedDate != null && selectedSlot != null) {
                    List<SalonSchedule> selectedAndNextSlots = [];
                    int selectedSlotIndex =
                        selectedDaySlots.indexOf(selectedSlot!);
                    for (int i = 0; i < widget.amountOfTimeslots; i++) {
                      if (selectedSlotIndex + i < selectedDaySlots.length) {
                        selectedAndNextSlots
                            .add(selectedDaySlots[selectedSlotIndex + i]);
                      }
                    }
                    Get.to(() => BookingSummaryScreen(
                          salon: widget.salon,
                          selectedDate: selectedDate!,
                          selectedTimeSlots: selectedAndNextSlots,
                          duration: widget.duration,
                          price: widget.price,
                          services: widget.services,
                        ));
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  alignment: Alignment.center,
                  width: MediaQuery.sizeOf(context).width,
                  height: 45,
                  decoration: BoxDecoration(
                      color:
                          selectedSlot == null ? Colors.white : Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        selectedSlot == null
                            ? 'Wybierz datę i godzinę'
                            : 'Zarezerwuj     ',
                        style: TextStyle(
                            color: selectedSlot == null
                                ? const Color.fromARGB(255, 24, 24, 24)
                                : Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
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
