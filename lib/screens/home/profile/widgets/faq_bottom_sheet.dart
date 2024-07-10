import 'package:findovio/providers/firebase_py_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:findovio/consts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Import your necessary dependencies

class FaqBottomSheet extends StatefulWidget {
  const FaqBottomSheet({super.key});

  @override
  State<FaqBottomSheet> createState() => _FaqBottomSheetState();
}

class _FaqBottomSheetState extends State<FaqBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.fromLTRB(25, 6, 25, 15),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE BAR
                const Text(
                  'FAQ',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 20, 20, 20),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ConstsWidgets.gapH20,

                // TITLE BAR
                const Text(
                  'Wciskając przycisk na dole możesz opisać swój problem lub zapytać nas o pomoc. '
                  'Nasi doradcy są do Twojej dyspozycji.',
                  style: TextStyle(
                    color: Color.fromARGB(255, 32, 32, 32),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Opisz w mailu najdokładniej jak potrafisz z czym masz problem, '
                  'w którym miejscu aplikacji, swój model telefonu. '
                  'Są to pomocne dla nas informacje, ale nie niezbędne, więc jeżeli masz kłopot '
                  'z uzyskaniem ich to pomiń je :)',
                  style: TextStyle(
                    color: Color.fromARGB(255, 54, 54, 54),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pamiętej, że Nasi konsultanci NIGDY nie zapytają Cię o żadne hasła, dane karty bankowej, czy loginy.',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 77, 77),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset(
                    'assets/images/help.png',
                    fit: BoxFit.contain,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        _composeEmail(context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                          return Colors.orangeAccent; // Domyślny kolor
                        }),
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                          return Colors
                              .white; // Biały kolor tekstu, gdy hasło jest prawidłowe
                        }),
                      ),
                      child: const Text('Otwórz wiadomość Email'),
                    ),
                  ],
                ),
              ],
            )));
  }

  void _composeEmail(BuildContext context) async {
    const email =
        'wardachd@outlook.com'; // Zmień na właściwy adres e-mail odbiorcy
    const subject = 'Mój problem';
    var userDataProvider = Provider.of<FirebasePyUserProvider>(context,
        listen:
            false); // Dodaj odwołanie do Twojego dostawcy danych użytkownika
    final bodyText =
        'Moje uid: ${userDataProvider.user!.firebaseUid}\nOpis problemu:\n\n\n\n\n\n-----------------\nInformacje dodatkowe:\n- Model telefonu:\n- Miejsce w aplikacji:\n';

    final mailtoLink = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject,
        'body': bodyText,
      },
    );

    try {
      await launchUrl(mailtoLink);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nie można otworzyć aplikacji mailowej.'),
        ),
      );
    }
  }
}
