import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';

class SalonElementAwait extends StatelessWidget {
  const SalonElementAwait({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.72,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 25.0,
          top: 10,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AnimateGradient(
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
              ]),
        ),
      ),
    );
  }
}
