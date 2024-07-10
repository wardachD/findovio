import 'package:animate_gradient/animate_gradient.dart';
import 'package:findovio/consts.dart';
import 'package:flutter/material.dart';

class BookingCardPlaceholder extends StatelessWidget {
  const BookingCardPlaceholder({Key? key}) : super(key: key);

  Widget animatedBG(double x, double y) {
    return SizedBox(
      width: x,
      height: y,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Text(
                'Rezerwacje',
                textAlign: TextAlign.start,
                style: TextStyle(
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color.fromARGB(255, 22, 22, 22)),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () async {},
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.16,
                    margin:
                        const EdgeInsets.only(right: 16.0, bottom: 20, top: 5),
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: AppColors.lightColorTextField,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.18,
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: animatedBG(
                                      70,
                                      MediaQuery.of(context).size.height *
                                          0.13))),
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
                                animatedBG(130, 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center, // Align contents to the left
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        animatedBG(80, 20),
                                        const SizedBox(height: 2),
                                        animatedBG(90, 20),
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
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.primaryLightColorText,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
