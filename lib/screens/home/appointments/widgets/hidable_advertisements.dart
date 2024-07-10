import 'package:flutter/material.dart';

class HidableColumnWidget extends StatelessWidget {
  const HidableColumnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 25),
                //   child: Text('Skorzystaj z promocji i zarezerwuj wizytę',
                //       style:
                //           TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                // ),
                // AdvertisementsWidget(optionalString: ' '),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Image.asset(
                'assets/images/pusto_tutaj.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
