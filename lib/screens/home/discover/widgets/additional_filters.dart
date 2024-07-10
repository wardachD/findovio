import 'package:findovio/consts.dart';
import 'package:flutter/material.dart';

class AdditionalFiltersWidget extends StatelessWidget {
  final List<FilterButtonData> filterButtons;

  const AdditionalFiltersWidget({super.key, required this.filterButtons});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstsWidgets.gapH8,
          const Text('dodatkowe filtry',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 210, // Maksymalna szerokość kafelka
              mainAxisSpacing: 15, // Odstęp pionowy między kafelkami
              crossAxisSpacing: 15,
              mainAxisExtent: 40, // Odstęp poziomy między kafelkami
            ),
            itemCount: filterButtons.length,
            itemBuilder: (context, index) {
              return GridTile(
                child: FilterButton(
                  title: filterButtons[index].title,
                  icon: filterButtons[index].icon,
                  onPressed: () {
                    // Tutaj dodaj logikę, która ma być wykonana po naciśnięciu przycisku.
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const FilterButton(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPressed});

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
        setState(() {
          isPressed = !isPressed;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isPressed
              ? Colors.white
              : const Color.fromARGB(255, 243, 243, 243),
          boxShadow: [
            BoxShadow(
              color: isPressed ? Colors.orange : Colors.white,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              widget.icon,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              widget.title,
              style: TextStyle(
                color: isPressed ? Colors.orange : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterButtonData {
  final String title;
  final IconData icon;

  FilterButtonData({required this.title, required this.icon});
}
