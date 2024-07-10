import 'package:animate_gradient/animate_gradient.dart';
import 'package:findovio/models/findovio_advertisement_model.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/utils/findovio_advertisement_widget.dart/custom_advertisement.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FindovioAdvertisementWidget extends StatelessWidget {
  final animateGradient = AnimateGradient(
      duration: const Duration(milliseconds: 1200),
      primaryBegin: Alignment.centerRight,
      primaryEnd: Alignment.centerRight,
      secondaryBegin: Alignment.centerLeft,
      secondaryEnd: Alignment.centerLeft,
      primaryColors: const [
        Color.fromARGB(202, 255, 255, 255),
        Color.fromARGB(160, 255, 172, 64)
      ],
      secondaryColors: const [
        Color.fromARGB(113, 255, 172, 64),
        Color.fromARGB(101, 255, 255, 255)
      ]);

  FindovioAdvertisementWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
      child: Column(
        children: [
          FutureBuilder<FindovioAdvertisement>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            height: 213,
                            child: animateGradient)));
              } else if (snapshot.hasError) {
                return Center(child: Text('Wystąpił błąd: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.id == 0) {
                return SizedBox(
                    width: 164.0, height: 92.4, child: animateGradient);
              } else {
                String imageUrl = snapshot.data!.url;
                return GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomAdvertisement(
                        advertisement: snapshot.data!,
                      ); // Wyświetlenie niestandardowego dialogu
                    },
                  ),
                  child: SizedBox(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const Center(
                            child: Text('Nie można załadować obrazka.'),
                          );
                        },
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: MediaQuery.sizeOf(context).width * 0.7,
            child: const Center(
              child: Text(
                'Oferta aktualna do 31.03.2024, potrzebujesz tylko zweryfikowany numer telefonu oraz wysłanie kodu polecającego',
                textAlign: TextAlign.center,
                // Dowolne ustawienia stylu tekstu, np.:
                style: TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(255, 44, 44, 44),
                  // Możesz dostosować również inne właściwości stylu tekstu
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<FindovioAdvertisement> fetchData() async {
    try {
      http.Client client = http.Client();
      FindovioAdvertisement advertisements =
          await fetchFindovioAdvertisement(client);
      return advertisements;
    } catch (e) {
      throw Exception('Wystąpił błąd: $e');
    }
  }
}
