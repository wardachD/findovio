import 'package:animate_gradient/animate_gradient.dart';
import 'package:findovio/consts.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/models/salon_schedule.dart';
import 'package:findovio/models/salon_working_hours.dart';
import 'package:findovio/models/user_appointment.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:findovio/providers/firebase_py_user_provider.dart';
import 'package:findovio/routes/app_pages.dart';
import 'package:findovio/screens/home/appointments/widgets/cancel_appointment_progress_indicator.dart';
import 'package:findovio/screens/home/appointments/widgets/show_appointment_description_with_friactionally_sizedbox.dart';
import 'package:findovio/screens/home/appointments/widgets/top_of_appointment_tile_with_date_and_status.dart';
import 'package:findovio/screens/home/main_page/main/salon_details_screen.dart';
import 'package:findovio/screens/home/main_page/main/screens/Booking/screens/booking_schedule.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AppointmentTile extends StatefulWidget {
  final UserAppointment userAppointment;
  final VoidCallback callback;

  const AppointmentTile({
    super.key,
    required this.userAppointment,
    required this.callback,
  });

  @override
  State<AppointmentTile> createState() => _AppointmentTileState();
}

class _AppointmentTileState extends State<AppointmentTile> {
  bool agreedToPublish = false;
  String userOpinion = '';
  int userStarOpinion = 4;
  double userRating = 0;
  String userName = '';
  final GlobalKey<_AppointmentTileState> myWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var userDataProvider =
        Provider.of<FirebasePyUserProvider>(context, listen: false);
    userName = userDataProvider.user!.firebaseName;
    bool buttonAnimateStart = false;

    String isMoreServices = (widget.userAppointment.services.length > 1)
        ? '  +${widget.userAppointment.services.length - 1} więcej'
        : '';

    final Future<String> salonAvatar =
        fetchOneSalons(http.Client(), widget.userAppointment.salon)
            .then((value) => getPhoto(value.avatar));
    final Future<SalonModel> salonInfo =
        fetchOneSalons(http.Client(), widget.userAppointment.salon);

    final formattedDate = widget.userAppointment.getFormattedDateOfBooking();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(15), // Updated borderRadius
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          topOfAppointmentTileWithDateAndStatus(
              widget: widget, formattedDate: formattedDate),
          divider(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.12,
                  width: MediaQuery.sizeOf(context).height * 0.12,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FutureBuilder<String>(
                          future: salonAvatar,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: AnimateGradient(
                                      duration:
                                          const Duration(milliseconds: 1200),
                                      primaryBegin: Alignment.centerRight,
                                      primaryEnd: Alignment.centerRight,
                                      secondaryBegin: Alignment.centerLeft,
                                      secondaryEnd: Alignment.centerLeft,
                                      primaryColors: const [
                                    Colors.white,
                                    Colors.orangeAccent
                                  ],
                                      secondaryColors: const [
                                    Colors.orangeAccent,
                                    Color.fromARGB(0, 255, 255, 255)
                                  ]));
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Błąd: ${snapshot.error}'));
                            } else {
                              String imageUrl =
                                  snapshot.data ?? ''; // Get the image URL
                              return InkWell(
                                onTap: () async {
                                  var salonToMove = await salonInfo;
                                  Get.toNamed(
                                    Routes.HOME_SALON,
                                    arguments: salonToMove,
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 0),
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundColor,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 0,
                                        blurRadius: 1,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    image: DecorationImage(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: const Column(),
                                ),
                              );
                            }
                          })),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: MediaQuery.sizeOf(context).width * 0.22,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        widget.userAppointment.salonName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryLightColorText,
                        ),
                      ),
                      const Text(
                        'Usługi:',
                        style: TextStyle(
                          color: AppColors.primaryLightColorText,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.50,
                        child: Text(
                          '${widget.userAppointment.services[0].title}$isMoreServices',
                          style: const TextStyle(
                            color: AppColors.primaryLightColorText,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          divider(),
          if (widget.userAppointment.status == 'C' ||
              widget.userAppointment.status == 'P')
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await showModalBottomSheet(
                        showDragHandle: true,
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return FractionallySizedBox(
                              heightFactor: 0.25,
                              widthFactor: 1,
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(25, 0, 25, 15),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Column(
                                        children: [
                                          Text(
                                            'Czy na pewno chcesz anulować wizytę?',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Color.fromARGB(
                                                    255, 20, 20, 20),
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            'Pamiętaj, że możesz zarezerwować ponownie w kilka kliknięć.',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 95, 95, 95),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppointmentCancellationButton(
                                            appointmentId:
                                                widget.userAppointment.id,
                                            callback: widget.callback,
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                Navigator.of(context).pop(),
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.37,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                border: Border.all(
                                                    color: Colors.orange,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const Text(
                                                'Cofnij',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]),
                              ));
                        },
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.37,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.orange, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Anuluj',
                            style: TextStyle(
                                color: Color.fromARGB(255, 20, 20, 20),
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  showAppointmentDescriptionWithFriactionallySizedBox(
                      widget: widget, context: context, salonInfo: salonInfo),
                ],
              ),
            ),
          if (widget.userAppointment.status == 'F')
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        bookAgainMethodOrReview(
                            buttonAnimateStart, context, "Review"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        bookAgainMethodOrReview(
                            buttonAnimateStart, context, "Book again"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (widget.userAppointment.status == 'X')
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  showAppointmentDescriptionWithFriactionallySizedBox(
                      widget: widget, context: context, salonInfo: salonInfo),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Container divider() {
    return Container(
      height: 0.4, // Gray line height
      color: Colors.grey,
      margin: const EdgeInsets.symmetric(horizontal: 20),
    );
  }

  Future<void> sendReview() async {
    if (agreedToPublish) {
      Map<String, dynamic> dataToSend = {
        'salon': widget.userAppointment.salon,
        'user_id': userName.split(' ')[0],
        'rating': userStarOpinion,
        'comment': userOpinion,
      };

      try {
        // showDialog(
        //   barrierColor: Colors.transparent,
        //   context: context,
        //   builder: (BuildContext context) {
        //     return Center(
        //       heightFactor: 1,
        //       widthFactor: 1,
        //       child: Container(
        //         width: MediaQuery.of(context).size.height * 0.10,
        //         height: MediaQuery.of(context).size.height * 0.10,
        //         decoration: BoxDecoration(
        //           color: Colors.white,
        //           borderRadius: BorderRadius.circular(12),
        //           boxShadow: [
        //             BoxShadow(
        //               color: const Color.fromARGB(255, 65, 65, 65)
        //                   .withOpacity(0.5),
        //               spreadRadius: 2,
        //               blurRadius: 6,
        //               offset: const Offset(0, 2), // Zmiana offsetu dla cienia
        //             ),
        //           ],
        //         ),
        //         child: Container(
        //           padding: const EdgeInsets.all(20),
        //           child: const CircularProgressIndicator(
        //             backgroundColor: Colors.transparent,
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        // );

        // Simulate sending the request (Replace this with your actual HTTP request)

        // Assuming sendPostReviewRequest is your function to send the request
        String result = await sendPostReviewRequest(dataToSend);

        // Handle the response based on the result (Success/Error)
        if (result == 'success') {
          if (context.mounted) {
            showDialog(
              barrierColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                return Center(
                  heightFactor: 1,
                  widthFactor: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 65, 65, 65)
                              .withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset:
                              const Offset(0, 2), // Zmiana offsetu dla cienia
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        const Icon(Icons.check_circle,
                            size: 48, color: Colors.green),
                        const SizedBox(height: 8),
                        const Text(
                          'Komentarz dodany!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => {Navigator.pop(context)},
                          child: const Text(
                            'Ok',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

// Zniknięcie dialogu po 2 sekundach
        } else if (result == 'not unique') {
          if (context.mounted) {
            showDialog(
              barrierColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                Future.delayed(const Duration(seconds: 3), () {});
                return Center(
                  heightFactor: 1,
                  widthFactor: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.21,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 65, 65, 65)
                              .withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset:
                              const Offset(0, 2), // Zmiana offsetu dla cienia
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        const Icon(Icons.check_circle,
                            size: 48,
                            color: Color.fromARGB(255, 255, 122, 113)),
                        const SizedBox(height: 8),
                        const Text(
                          'Możesz dodać tylko jeden komentarz',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => {Navigator.pop(context)},
                          child: const Text(
                            'Ok',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        } else {
          // Handle no connection scenario
          if (context.mounted) {
            showDialog(
              barrierColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                return Center(
                  heightFactor: 1,
                  widthFactor: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.21,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 65, 65, 65)
                              .withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset:
                              const Offset(0, 2), // Zmiana offsetu dla cienia
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        const Icon(Icons.check_circle,
                            size: 48,
                            color: Color.fromARGB(255, 255, 122, 113)),
                        const SizedBox(height: 8),
                        const Text(
                          'Błąd',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => {Navigator.pop(context)},
                          child: const Text(
                            'Ok',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          showDialog(
            barrierColor: Colors.transparent,
            context: context,
            builder: (BuildContext context) {
              return Center(
                heightFactor: 1,
                widthFactor: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.21,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 65, 65, 65)
                            .withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(0, 2), // Zmiana offsetu dla cienia
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      const Icon(Icons.check_circle,
                          size: 48, color: Color.fromARGB(255, 255, 122, 113)),
                      const SizedBox(height: 8),
                      Text(
                        'Błąd ' + e.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => {Navigator.pop(context)},
                        child: const Text(
                          'Ok',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }
    }
  }

  GestureDetector bookAgainMethodOrReview(
      bool buttonAnimateStart, BuildContext context, String buttonOption) {
    return GestureDetector(
      onTap: () async {
        if (buttonOption == "Book again") {
          buttonAnimateStart = true;
          // variables
          int totalDuration = 0;
          num totalPrice = 0;
          int timeslotsNeeded = 0;

          // salon
          var salon = await fetchSalons(http.Client());
          salon = salon
              .where((salon) => salon.id == widget.userAppointment.salon)
              .toList();
          SalonModel selectedSalon = salon
              .firstWhere((salon) => salon.id == widget.userAppointment.salon);

          // services
          widget.userAppointment.services;

          // schedule
          Future<List<SalonSchedule>> schedule =
              fetchSalonSchedules(http.Client(), widget.userAppointment.salon);

          // working hours
          List<SalonWorkingHours> workingHoursList =
              await fetchSalonWorkingHours(
                  http.Client(), widget.userAppointment.salon);

          if (workingHoursList.isNotEmpty) {
            final timeslotLength = workingHoursList[0]
                .timeSlotLength; // Assuming the first element
            totalDuration = 0;
            totalPrice = 0;
            timeslotsNeeded = 0;

            // Calculate total duration and price
            for (var service in widget.userAppointment.services) {
              totalDuration += service.durationMinutes;
              totalPrice += num.parse(service.price);
            }

            // Calculate timeslotsNeeded
            timeslotsNeeded = (totalDuration + timeslotLength - 1) ~/
                timeslotLength; // Rounded up division
          }

          Future<List<SalonWorkingHours>> workingHoursFuture =
              Future<List<SalonWorkingHours>>.value(workingHoursList);

          Get.to(() => BookingSchedule(
              salon: selectedSalon,
              services: widget.userAppointment.services,
              schedule: schedule,
              workingHours: workingHoursFuture,
              duration: totalDuration,
              price: totalPrice,
              amountOfTimeslots: timeslotsNeeded));
          // Now, you have totalDuration, totalPrice, and timeslotsNeeded calculated.
          // You can use these values as needed.
          buttonAnimateStart = false;
        }
        if (buttonOption == "Review") {
          showModalBottomSheet(
            showDragHandle: true,
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  color: Colors.white,
                ),
                margin: MediaQuery.of(context).viewInsets,
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter myState) {
                    return FractionallySizedBox(
                      heightFactor: 0.6,
                      widthFactor: 1,
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  const Text(
                                    'Oceń wizytę',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // Gwiazdki do oceny salonu
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(5, (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          // Zmiana oceny po kliknięciu
                                          myState(() {
                                            userStarOpinion = index + 1;
                                            // Zapisz ocenę
                                          });
                                        },
                                        child: Icon(
                                          index < userStarOpinion.floor()
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: index < userStarOpinion.floor()
                                              ? Colors.orange
                                              : null,
                                          size: 32,
                                        ),
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 20),
                                  // Formularz opinii o salonie
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Pole do wprowadzenia opinii tekstowej
                                      TextField(
                                        decoration: const InputDecoration(
                                          labelText: 'Powiedz nam coś więcej',
                                        ),
                                        maxLines: 3,
                                        // Zapisz wprowadzoną opinię do zmiennej lub modelu
                                        onChanged: (value) {
                                          userOpinion = value;
                                        },
                                      ),
                                      const SizedBox(height: 12),

                                      buildAgreementCheckBox(context, myState),
                                      ConstsWidgets.gapH16,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.4,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    color: Colors.orangeAccent,
                                                    width: 1.5),
                                              ),
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Anuluj',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 36, 36, 36),
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (agreedToPublish) {
                                                sendReview();
                                              }
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.4,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: agreedToPublish
                                                    ? Colors.orangeAccent
                                                    : const Color.fromARGB(
                                                        255, 199, 199, 199),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Wyślij',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.sizeOf(context).width * 0.4,
        height: 36,
        decoration: BoxDecoration(
          color: buttonOption == 'Book again' ? Colors.orange : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: buttonOption == 'Book again'
                  ? Colors.transparent
                  : Colors.orangeAccent,
              width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonOption == 'Book again' ? 'Rezerwuj ponownie' : 'Oceń',
              style: TextStyle(
                  color: buttonOption == 'Book again'
                      ? Colors.white
                      : const Color.fromARGB(255, 20, 20, 20),
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Row buildAgreementCheckBox(BuildContext context, Function setState) {
    return Row(
      children: [
        Checkbox(
          value: agreedToPublish,
          onChanged: (bool? newValue) {
            ScaffoldMessenger.of(context)
                .hideCurrentSnackBar(); // Hide any existing snackbar
            setState(() {
              agreedToPublish = newValue ?? false;
            });
          },
        ),
        Expanded(
          child: Builder(
            builder: (BuildContext context) {
              return const Text(
                'Zgadzam się na publikowanie mojego imienia, opinii, daty rezerwacji i/lub zdjęcia oraz oświadczam, że wiem o możliwości usunięcia wpisu widocznego na profilu Salonu po uprzednim zwróceniu się do Findovio.',
                style: TextStyle(
                  fontSize: 12,
                  // Dodatkowe style dla tekstu
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
