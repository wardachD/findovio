import 'package:cached_network_image/cached_network_image.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/routes/app_pages.dart';
import 'package:findovio/screens/home/main_page/main/salon_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'compact_category_distance_review.dart';

class CompactSalonTile extends StatelessWidget {
  final SalonModel salon;
  final bool showDistances;

  const CompactSalonTile(
      {super.key, required this.salon, required this.showDistances});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(
        Routes.HOME_SALON,
        arguments: salon,
      ),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        height: 135, // Adjust height as needed
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromARGB(62, 126, 126, 126),
                  blurRadius: 2,
                  offset: Offset(0, 3))
            ]),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Image on the left
              SizedBox(
                width: 130,
                height: 130,
                // Adjust width as needed
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: salon.avatar,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Text on the right
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CompactCategoryDistanceReview(
                            categoryName: salon.flutterCategory,
                            review: salon.review,
                            distance: salon.distanceFromQuery,
                            showDistances: showDistances,
                          ),
                          if (salon.salonProperties.contains(6))
                            Icon(
                              MdiIcons.circle,
                              size: 4,
                              color: const Color.fromARGB(255, 167, 167, 167),
                            ),
                          if (salon.salonProperties.contains(6))
                            Row(
                              children: [
                                Icon(
                                  MdiIcons.car,
                                  size: 16,
                                  color: const Color.fromARGB(255, 56, 56, 56),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Dojazd do klienta',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 56, 56, 56),
                                  ),
                                  softWrap: true,
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            salon.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            softWrap: true,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '${salon.addressCity} ${salon.addressPostalCode}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 61, 61, 61),
                                ),
                                softWrap: true,
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                MdiIcons.star,
                                size: 16,
                                color: salon.review != 0.1
                                    ? Colors.orange
                                    : const Color.fromARGB(255, 61, 61, 61),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                salon.review != 0.1
                                    ? salon.review.toString()
                                    : 'Brak',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          if (showDistances)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(MdiIcons.navigation,
                                    size: 16, color: Colors.orange),
                                const SizedBox(width: 4),
                                Text(
                                  getFormattedDistance(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getFormattedDistance() {
    if (salon.distanceFromQuery >= 1000) {
      return '${(salon.distanceFromQuery / 1000).toStringAsFixed(1)} km';
    } else {
      return '${salon.distanceFromQuery.toInt()} m';
    }
  }
}
