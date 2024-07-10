import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapButton extends StatelessWidget {
  final String city;
  final String street;
  final String streetNumber;
  final String postcode;
  final String phoneNumber;

  const MapButton({
    super.key,
    required this.city,
    required this.street,
    required this.streetNumber,
    required this.postcode,
    required this.phoneNumber,
  });

  void openMaps() async {
    String formattedAddress = '$street $streetNumber, $postcode $city';
    MapsLauncher.launchQuery(formattedAddress);
  }

  void openCall() async {
    Uri phoneNumberToUri = Uri.parse("tel:$phoneNumber");
    launchUrl(phoneNumberToUri);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () async {
                openCall();
              },
              child: Container(
                  width: 120,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color.fromARGB(255, 32, 32, 32),
                          width: 0.7)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(MdiIcons.phone),
                      const Text('Zadzwoń'),
                    ],
                  )),
            ),
          ),
          InkWell(
            onTap: () {
              openMaps();
            },
            child: Container(
                width: 120,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color.fromARGB(255, 32, 32, 32),
                        width: 0.7)),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(MdiIcons.googleMaps),
                          const Text('Nawiguj'),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
