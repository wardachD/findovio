import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';

class SalonListElementAwait extends StatelessWidget {
  const SalonListElementAwait({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(25, 0, 0, 12),
            child: Text(
              'Dla Ciebie',
              textAlign: TextAlign.start,
              style: TextStyle(
                  letterSpacing: 0.1,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color.fromARGB(255, 22, 22, 22)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            children: List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 20,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.22,
                    height: 35,
                    child: AnimateGradient(
                        duration: const Duration(milliseconds: 1200),
                        primaryBegin: Alignment.centerRight,
                        primaryEnd: Alignment.centerRight,
                        secondaryBegin: Alignment.centerLeft,
                        secondaryEnd: Alignment.centerLeft,
                        primaryColors: const [
                          Color.fromARGB(202, 255, 255, 255),
                          Color.fromARGB(159, 238, 238, 238),
                        ],
                        secondaryColors: const [
                          Color.fromARGB(159, 238, 238, 238),
                          Color.fromARGB(202, 255, 255, 255),
                        ]),
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.sizeOf(context).width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: AnimateGradient(
                        duration: const Duration(milliseconds: 1200),
                        primaryBegin: Alignment.centerRight,
                        primaryEnd: Alignment.centerRight,
                        secondaryBegin: Alignment.centerLeft,
                        secondaryEnd: Alignment.centerLeft,
                        primaryColors: const [
                          Color.fromARGB(202, 255, 255, 255),
                          Color.fromARGB(159, 238, 238, 238),
                        ],
                        secondaryColors: const [
                          Color.fromARGB(159, 238, 238, 238),
                          Color.fromARGB(202, 255, 255, 255),
                        ]),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
