import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TitleBar extends StatelessWidget {
  final String text;

  const TitleBar({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      // Jeśli text jest pusty, zwróć pusty kontener
      return const SizedBox.shrink();
    }
    List<String> lista = [
      'co dziś znajdziemy?',
      'Fryzjer',
      'Paznokcie',
      'Masaż',
      'Barber',
      'Makijaż',
      'Pedicure',
      'Manicure',
    ];

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.05,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$text ',
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Color.fromARGB(255, 31, 31, 31),
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1,
              letterSpacing: 0.21,
            ),
          ),
          if (lista.contains(text))
            Icon(
              MdiIcons.chevronDoubleDown,
              weight: 900,
              color: const Color.fromARGB(255, 53, 53, 53),
            ),
        ],
      ),
    );
  }
}

class TitleBarWithoutHeight extends StatelessWidget {
  final String text;

  const TitleBarWithoutHeight({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      // Jeśli text jest pusty, zwróć pusty kontener
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.05,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$text ',
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Color.fromARGB(255, 31, 31, 31),
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1,
              letterSpacing: 0.21,
            ),
          ),
          Icon(
            MdiIcons.chevronDoubleDown,
            weight: 900,
            color: const Color.fromARGB(255, 53, 53, 53),
          ),
        ],
      ),
    );
  }
}
