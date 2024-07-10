import 'package:animate_gradient/animate_gradient.dart';
import 'package:findovio/consts.dart';

import 'package:flutter/material.dart';

class AppointmentTilePlaceholder extends StatefulWidget {
  const AppointmentTilePlaceholder({
    super.key,
  });

  @override
  State<AppointmentTilePlaceholder> createState() =>
      _AppointmentTilePlaceholderState();
}

class _AppointmentTilePlaceholderState
    extends State<AppointmentTilePlaceholder> {
  @override
  Widget build(BuildContext context) {
    var animateGradient = AnimateGradient(
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
        ]);
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Container(
        width: double.infinity,
        height: 120,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(15), // Updated borderRadius
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(16),
                width: MediaQuery.sizeOf(context).width,
                height: 50,
                child: Container(
                  child: animateGradient,
                )),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.12,
                      width: MediaQuery.sizeOf(context).height * 0.12,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Center(child: animateGradient),
                      )),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).width * 0.22,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                            width: 120, height: 20, child: animateGradient),
                        SizedBox(width: 60, height: 20, child: animateGradient),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.50,
                          child: SizedBox(
                              width: 20, height: 20, child: animateGradient),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.35,
                    height: 30,
                    child: animateGradient,
                  ),
                  SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.35,
                      height: 30,
                      child: animateGradient)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container Divider() {
    return Container(
      height: 0.4, // Gray line height
      color: Colors.grey,
      margin: const EdgeInsets.symmetric(horizontal: 20),
    );
  }

  Padding TopOfAppointmentTileWithDateAndStatus(String? formattedDate) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                '',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
