import 'package:findovio/consts.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/models/user_appointment.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:findovio/screens/home/appointments/widgets/open_google_maps_button_with_address.dart';
import 'package:findovio/utilities/authentication/months_utils.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;

class BookingCard extends StatelessWidget {
  final UserAppointment appointment;
  final int amountOfAppointments;

  const BookingCard(
      {Key? key, required this.appointment, required this.amountOfAppointments})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime jsonToDate = DateTime.parse(appointment.dateOfBooking);
    String bookingHour =
        '${appointment.timeslots[0].timeFrom.split(':')[0]}:${appointment.timeslots[0].timeFrom.split(':')[1]} ';
    int amountOfServicesToPrint = appointment.services.length - 1;
    String isMoreServices =
        (amountOfServicesToPrint > 1) ? '+ $amountOfServicesToPrint more' : '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
      child: GestureDetector(
        onTap: () async {
          final Future<SalonModel> salonInfo =
              fetchOneSalons(http.Client(), appointment.salon);
          showModalBottomSheet(
            showDragHandle: true,
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return FractionallySizedBox(
                heightFactor: 0.6,
                widthFactor: 1,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          const Text(
                            'Szczegóły',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Informacje o salonie
                          Container(
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
                                FutureBuilder<SalonModel>(
                                  future:
                                      salonInfo, // Zakładam, że salonInfo to Future<SalonModel>
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator(); // Wyświetl loader podczas oczekiwania na dane
                                    } else if (snapshot.hasError) {
                                      return Text(
                                          'Wystąpił błąd: ${snapshot.error}'); // Wyświetl komunikat w przypadku błędu
                                    } else if (!snapshot.hasData ||
                                        snapshot.data == null) {
                                      return const Text(
                                          'Brak danych'); // Wyświetl komunikat, jeśli brak danych
                                    } else {
                                      final salon = snapshot.data!;

                                      // Tutaj możesz użyć danych z salon, np.:
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Salon:',
                                              ),
                                              Text(
                                                salon.name,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Miasto:',
                                              ),
                                              Text(
                                                salon.addressCity,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          // Pozostałe informacje można dodać w podobny sposób
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Ulica:',
                                              ),
                                              Text(
                                                '${salon.addressStreet}, ${salon.addressNumber}',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          ConstsWidgets.gapH12,
                                          MapButton(
                                            city: salon.addressCity,
                                            street: salon.addressStreet,
                                            streetNumber: salon.addressNumber,
                                            postcode: salon.addressPostalCode,
                                            phoneNumber: salon.phoneNumber,
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          ConstsWidgets.gapH8,
                          // Informacje o usługach
                          Container(
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
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Usługi',
                                      style: TextStyle(),
                                    ),
                                    const SizedBox(height: 12),
                                    // Wyświetlenie listy zabookowanych usług
                                    for (final service in appointment.services)
                                      _buildDetailRow(
                                          service.title, '${service.price} zł'),
                                    ConstsWidgets.gapH4
                                    // Wyświetlenie całkowitej kwoty
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ConstsWidgets.gapH8,
                          // Informacje o płatności
                          Container(
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
                                        color: const Color.fromARGB(
                                            255, 54, 54, 54)),
                                    const SizedBox(width: 6),
                                    // Tekst "Sposób płatności"
                                    const Text(
                                      'Do zapłaty:',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                // Napis "Na miejscu"
                                Text(
                                  appointment.totalAmount,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ConstsWidgets.gapH8,
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Container(
          width: amountOfAppointments < 2
              ? MediaQuery.of(context).size.width * 0.88
              : MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.16,
          margin: const EdgeInsets.only(right: 0.0, bottom: 20, top: 5),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: AppColors.lightColorTextField,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.14,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        MonthsUtils.getMonthName(jsonToDate.month)
                            .substring(0, 3)
                            .toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primaryColorText,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '${jsonToDate.day}',
                        style: const TextStyle(
                          color: AppColors.primaryColorText,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        '${jsonToDate.year % 2000}',
                        style: const TextStyle(
                          color: AppColors.primaryColorText,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '${appointment.services[0].title} $isMoreServices',
                        style: const TextStyle(
                            color: AppColors.primaryColorText,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // Align contents to the left
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.place,
                                    size: 15,
                                    color: Color.fromARGB(255, 80, 80, 80),
                                  ),
                                  const SizedBox(width: 4),
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.38,
                                    child: Text(
                                      appointment.salonName,
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color:
                                              AppColors.primaryLightColorText,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.watch_later,
                                    size: 13,
                                    color: Color.fromARGB(255, 87, 87, 87),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    bookingHour,
                                    style: const TextStyle(
                                        color: AppColors.primaryLightColorText,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    appointment.status == 'C'
                                        ? Icons.check_circle_rounded
                                        : Icons.pending,
                                    size: 15,
                                    color: appointment.status == 'C'
                                        ? Colors.green
                                        : AppColors.accentColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    appointment.status == 'C'
                                        ? 'Potwierdzona'
                                        : 'Oczekująca',
                                    style: TextStyle(
                                        color: appointment.status == 'C'
                                            ? Colors.green
                                            : AppColors.accentColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height,
                width: 30,
                child: Icon(
                  MdiIcons.dotsHorizontal,
                  color: AppColors.primaryLightColorText,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
