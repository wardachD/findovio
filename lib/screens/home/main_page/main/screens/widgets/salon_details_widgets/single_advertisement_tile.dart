import 'package:animate_gradient/animate_gradient.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:findovio/models/advertisement_model.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:findovio/routes/app_pages.dart';
import 'package:findovio/screens/home/main_page/main/salon_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SingleAdvertisementTile extends StatefulWidget {
  final Advertisement advertisement;

  const SingleAdvertisementTile({Key? key, required this.advertisement})
      : super(key: key);

  @override
  State<SingleAdvertisementTile> createState() =>
      _SingleAdvertisementTileState();
}

class _SingleAdvertisementTileState extends State<SingleAdvertisementTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: GestureDetector(
        onTap: () async {
          setState(() {});
          SalonModel salon =
              await fetchOneSalons(http.Client(), widget.advertisement.salon);

          // Navigating to the SalonDetailsScreen with a hero animation
          Get.toNamed(
            Routes.HOME_SALON,
            arguments: salon,
          );
        },
        child: Hero(
          tag: "salonHero_${widget.advertisement.salon}",
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.2,
            margin: const EdgeInsets.only(right: 16.0, bottom: 10),
            decoration: BoxDecoration(
              boxShadow: widget.advertisement.promotionLevel == 1
                  ? [
                      const BoxShadow(
                          color: Colors.orange,
                          blurRadius: 5.5,
                          spreadRadius: 3)
                    ]
                  : [const BoxShadow()],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.advertisement.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
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
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.black.withOpacity(1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        boxShadow: widget.advertisement.promotionLevel == 1
                            ? [
                                const BoxShadow(
                                    color: Color.fromARGB(141, 255, 153, 0),
                                    blurRadius: 2,
                                    spreadRadius: 1,
                                    offset: Offset(0, 2))
                              ]
                            : widget.advertisement.promotionLevel == 2
                                ? [
                                    const BoxShadow(
                                        color: Color.fromARGB(141, 255, 153, 0),
                                        blurRadius: 2,
                                        spreadRadius: 1,
                                        offset: Offset(0, 1))
                                  ]
                                : [const BoxShadow()],
                        color: const Color.fromARGB(255, 88, 88, 88)
                            .withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.advertisement.titleLine1,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.advertisement.titleLine2,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.advertisement.textLine1,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        // Add other text fields if needed
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// [
// {
//     "day_of_week": 1,
//     "open_time": "08:00:00",
//     "close_time":"17:00:00",
//     "time_slot_length": 15,
//     "salon": 16
// },
// {
//     "day_of_week": 2,
//     "open_time": "08:00:00",
//     "close_time": "17:00:00",
//     "time_slot_length": 15,
//     "salon": 16
// },
// {
//     "day_of_week": 3,
//     "open_time": "08:00:00",
//     "close_time": "17:00:00",
//     "time_slot_length": 15,
//     "salon": 16
// },
// {
//     "day_of_week": 4,
//     "open_time": "08:00:00",
//     "close_time": "17:00:00",
//     "time_slot_length": 15,
//     "salon": 16
// },
// {
//     "day_of_week": 5,
//     "open_time": "08:00:00",
//     "close_time": "17:00:00",
//     "time_slot_length": 15,
//     "salon": 16
// },
// {
//     "day_of_week": 6,
//     "open_time": "08:00:00",
//     "close_time": "17:00:00",
//     "time_slot_length": 15,
//     "salon": 16
// }
// ]