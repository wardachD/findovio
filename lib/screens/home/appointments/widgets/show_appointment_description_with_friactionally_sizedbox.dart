import 'package:findovio/consts.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/screens/home/appointments/widgets/appointments_tile.dart';
import 'package:findovio/screens/home/appointments/widgets/build_detail_row.dart';
import 'package:findovio/screens/home/appointments/widgets/open_google_maps_button_with_address.dart';
import 'package:findovio/screens/home/appointments/widgets/status_box.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class showAppointmentDescriptionWithFriactionallySizedBox
    extends StatelessWidget {
  const showAppointmentDescriptionWithFriactionallySizedBox({
    super.key,
    required this.widget,
    required this.context,
    required this.salonInfo,
  });

  final AppointmentTile widget;
  final BuildContext context;
  final Future<SalonModel> salonInfo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                                                  fontWeight: FontWeight.w600),
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
                                                  fontWeight: FontWeight.w500),
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
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Status:',
                                            ),
                                            StatusContainer(
                                              status:
                                                  widget.userAppointment.status,
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
                                  for (final service
                                      in widget.userAppointment.services)
                                    buildDetailRow(
                                        label: service.title,
                                        value: '${service.price} zł'),
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
                                widget.userAppointment.totalAmount,
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
        alignment: Alignment.center,
        width: MediaQuery.sizeOf(context).width * 0.37,
        height: 36,
        decoration: BoxDecoration(
            color: Colors.orange, borderRadius: BorderRadius.circular(12)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Szczegóły',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
