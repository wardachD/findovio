import 'package:animate_gradient/animate_gradient.dart';
import 'package:findovio/models/salon_working_hours.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:findovio/screens/home/appointments/widgets/open_google_maps_button_with_address.dart';
import 'package:flutter/material.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SalonDetails extends StatelessWidget {
  final SalonModel salonModel;
  SalonDetails({super.key, required this.salonModel});

  final animateGradient = ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      width: 100,
      height: 20,
      padding: EdgeInsets.symmetric(vertical: 2),
      child: AnimateGradient(
          duration: const Duration(milliseconds: 1200),
          primaryBegin: Alignment.centerRight,
          primaryEnd: Alignment.centerRight,
          secondaryBegin: Alignment.centerLeft,
          secondaryEnd: Alignment.centerLeft,
          primaryColors: const [
            Color.fromARGB(202, 255, 255, 255),
            Color.fromARGB(55, 230, 230, 230),
          ],
          secondaryColors: const [
            Color.fromARGB(57, 212, 212, 212),
            Color.fromARGB(202, 255, 255, 255),
          ]),
    ),
  );

  String _formatTime(String time) {
    // Podziel czas na części
    List<String> parts = time.split(':');
    // Sprawdź, czy pierwsza część ma długość 2 i zaczyna się od zera, jeśli tak, usuń zero wiodące
    if (parts.isNotEmpty && parts[0].length == 2 && parts[0][0] == '0') {
      time = parts[0].substring(1) + ':' + parts[1];
    }
    // Usuń sekundy, jeśli są obecne
    if (time.length > 5 && time[5] == ':') {
      return time.substring(0, 5);
    }
    // W przeciwnym razie zwróć oryginalny czas
    return time;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('O nas',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(height: 5),
                      Text(
                        "${salonModel.about}",
                        style: const TextStyle(
                            letterSpacing: 0.7,
                            fontSize: 14,
                            color: Color.fromARGB(255, 90, 89, 89)),
                      ),
                      const SizedBox(height: 25),
                      const Text('Godziny otwarcia',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(height: 8),

                      // Użycie Row do wyświetlenia dni tygodnia i godzin otwarcia
                      Row(
                        children: [
                          // Kolumna z dniami tygodnia
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Poniedziałek'),
                                Text('Wtorek'),
                                Text('Środa'),
                                Text('Czwartek'),
                                Text('Piątek'),
                                Text('Sobota'),
                                Text('Niedziela'),
                              ],
                            ),
                          ),

                          // Kolumna z godzinami otwarcia
                          Expanded(
                            child: FutureBuilder<List<SalonWorkingHours>>(
                              future: fetchSalonWorkingHours(
                                  http.Client(), salonModel.id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // Pokaż kolumnę z 7 wierszami podczas ładowania
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: List.generate(7, (index) {
                                      return animateGradient;
                                    }),
                                  );
                                } else if (snapshot.hasError) {
                                  // Pokaż błąd, jeśli wystąpił
                                  return Text('Błąd: ${snapshot.error}');
                                } else {
                                  // Po załadowaniu, generuj kolumnę z 7 wierszami
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: List.generate(7, (index) {
                                      // Sprawdź, czy są dostępne godziny otwarcia dla danego dnia tygodnia
                                      var hoursForDay =
                                          snapshot.data!.firstWhere(
                                        (element) =>
                                            element.dayOfWeek == (index + 1),
                                        orElse: () => SalonWorkingHours(
                                          id: 0,
                                          dayOfWeek: 0,
                                          openTime: '',
                                          closeTime: '',
                                          timeSlotLength: 0,
                                          salon: 0,
                                        ),
                                      );

                                      // Wyświetl godziny otwarcia dla danego dnia tygodnia
                                      // Wyświetl godziny otwarcia dla danego dnia tygodnia
                                      return Text(
                                        hoursForDay.dayOfWeek == index + 1
                                            ? '${_formatTime(hoursForDay.openTime)} - ${_formatTime(hoursForDay.closeTime)}'
                                            : 'Zamknięte',
                                      );
                                    }),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text('Kontakt',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                ),
              ),
              MapButton(
                city: salonModel.addressCity,
                street: salonModel.addressStreet,
                streetNumber: salonModel.addressNumber,
                postcode: salonModel.addressPostalCode,
                phoneNumber: salonModel.phoneNumber,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
