import 'package:findovio/models/advertisement_model.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/salon_details_widgets/single_advertisement_tile.dart';
import 'package:flutter/material.dart';

class AdvertisementsTiles extends StatelessWidget {
  final List<Advertisement> advertisements;
  final String optionalString;

  const AdvertisementsTiles(
      {Key? key, required this.advertisements, required this.optionalString})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: advertisements
                  .map((advertisement) => SingleAdvertisementTile(
                        advertisement: advertisement,
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
