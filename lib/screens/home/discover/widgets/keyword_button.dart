import 'package:findovio/models/discover_page_keywords_list.dart';
import 'package:flutter/material.dart';

class KeywordButton extends StatelessWidget {
  final DiscoverPageKeywordsList? keyword;
  final String? city;
  final Function()? callback;

  const KeywordButton({super.key, this.keyword, this.city, this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      margin: const EdgeInsets.all(4),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color.fromARGB(255, 219, 219, 219)),
          color: const Color.fromARGB(255, 250, 250, 250),
        ), // Dostosuj szerokość kontenera do własnych potrzeb.
        height: 30,
        child: Text(
          keyword != null
              ? keyword!.word
              : city == null
                  ? 'Błąd'
                  : city!,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
