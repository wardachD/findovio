import 'package:findovio/models/salon_model.dart';
import 'package:flutter/material.dart';

import 'salon_avatar.dart';

class SalonAvatarList extends StatelessWidget {
  final List<SalonModel> salons;

  const SalonAvatarList({super.key, required this.salons});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: salons
                  .map((salon) => SalonAvatar(
                        salon: salon,
                        showDistanes: false,
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
