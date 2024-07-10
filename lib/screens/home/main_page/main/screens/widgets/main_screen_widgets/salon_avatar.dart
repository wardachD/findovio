import 'package:cached_network_image/cached_network_image.dart';
import 'package:findovio/consts.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:findovio/providers/favorite_salons_provider.dart';
import 'package:findovio/routes/app_pages.dart';
import 'package:findovio/screens/home/main_page/main/salon_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import 'category.dart';

class SalonAvatar extends StatefulWidget {
  final SalonModel salon;
  final bool showDistanes;

  const SalonAvatar(
      {super.key, required this.salon, required this.showDistanes});

  @override
  State<SalonAvatar> createState() => _SalonAvatarState();
}

class _SalonAvatarState extends State<SalonAvatar> {
  late FavoriteSalonsProvider userDataProvider;
  late bool isSalonFavorite;

  @override
  void initState() {
    super.initState();
    userDataProvider =
        Provider.of<FavoriteSalonsProvider>(context, listen: false);
    isSalonFavorite = userDataProvider.salons.contains(widget.salon);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 20),
      child: FutureBuilder<String>(
        future: getPhoto(widget.salon.avatar),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Wyświetlamy CircularProgressIndicator, gdy trwa pobieranie obrazka
            return const SizedBox(
                // width: MediaQuery.of(context).size.width * 0.7,
                // height: MediaQuery.of(context).size.height * 0.35,
                // child: const Center(
                //   child: CircularProgressIndicator(),
                // ),
                );
          } else if (snapshot.hasError) {
            // Obsługa błędów
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.35,
              child: const Center(
                child: Text('An error has occurred!'),
              ),
            );
          } else {
            return GestureDetector(
              onTap: () {
                print(Get.currentRoute);
                Get.toNamed(
                  '/home/salon',
                  arguments: widget.salon,
                  preventDuplicates: false,
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (widget.salon.review != 0.1)
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(12)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromARGB(88, 0, 0, 0),
                                      blurRadius: 16.0)
                                ]),
                            height: MediaQuery.sizeOf(context).height * 0.06,
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                if (widget.salon.review != 0.1)
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColors.lightColorTextField,
                                      ),
                                      child: Text(
                                        widget.salon.review.toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color:
                                              Color.fromARGB(255, 31, 31, 31),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (widget.salon.review != 0.1)
                                  SmoothStarRating(
                                    rating: widget.salon.review,
                                    size: 20,
                                    color: Colors.orangeAccent,
                                    borderColor: AppColors.lightColorTextField,
                                    filledIconData: Icons.star,
                                    halfFilledIconData: Icons.star_half,
                                    defaultIconData: Icons.star_border,
                                    starCount: 5,
                                    allowHalfRating: true,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      if (widget.salon.review == 0.1)
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            height: MediaQuery.sizeOf(context).height * 0.06,
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.lightColorTextField,
                                    ),
                                    child: const Text(
                                      'Brak ocen',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color.fromARGB(255, 31, 31, 31),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 250,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Color.fromARGB(255, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Category(
                                      categoryName:
                                          widget.salon.flutterCategory),
                                  if (widget.showDistanes)
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Icon(
                                          MdiIcons.circle,
                                          size: 3,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 0),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.navigation,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${(widget.salon.distanceFromQuery / 1000).toStringAsFixed(1)} km',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (widget.salon.salonProperties.contains(6))
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Icon(
                                          MdiIcons.circle,
                                          size: 3,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              MdiIcons.car,
                                              size: 16,
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                            const SizedBox(width: 4),
                                            Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.25,
                                              child: const Text(
                                                'Dojazd do klienta',
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 12,
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                ),
                                                softWrap: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width:
                                          200, // Adjust the width according to your needs
                                      child: Text(
                                        '${widget.salon.addressCity} ${widget.salon.addressPostalCode}, ${widget.salon.addressStreet} ${widget.salon.addressNumber}',
                                        style: const TextStyle(
                                            fontSize: 13, color: Colors.white),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ConstsWidgets.gapW16,
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                                child: Text(
                                  widget.salon.name,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                  softWrap: true,
                                ),
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
        },
      ),
    );
  }
}
