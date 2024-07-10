import 'package:cached_network_image/cached_network_image.dart';
import 'package:findovio/consts.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:findovio/providers/favorite_salons_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class SalonAvatarSearch extends StatefulWidget {
  final SalonModel salon;
  final bool showDistances;

  const SalonAvatarSearch({
    super.key,
    required this.salon,
    required this.showDistances,
  });

  @override
  State<SalonAvatarSearch> createState() => _SalonAvatarState();
}

class _SalonAvatarState extends State<SalonAvatarSearch> {
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
            return const SizedBox();
          } else if (snapshot.hasError) {
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
                Get.toNamed(
                  '/home/salon',
                  arguments: widget.salon,
                  preventDuplicates: false,
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: CachedNetworkImage(
                      imageUrl: snapshot.data ?? '',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ReviewWidget(count: widget.salon.review),
                  Text(
                    widget.salon.name,
                    style: const TextStyle(
                      fontSize: 18,
                      letterSpacing: 0.5,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                  ),
                  Text(
                    '${widget.salon.addressCity}, ${widget.salon.addressStreet} ${widget.salon.addressNumber}',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                    softWrap: true,
                  ),
                  Divider(
                    height: 24,
                    color: Colors.black26,
                  ),
                  Column(
                    children: widget.salon.categories[0].services
                        .take(3)
                        .map((service) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${service.durationMinutes.toString()} minut',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            Text(
                              '€${service.price}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class ReviewWidget extends StatelessWidget {
  const ReviewWidget({
    super.key,
    required this.count,
  });

  final double count;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: count != 0.1
            ? Row(
                children: [
                  Text(
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 4),
                  SmoothStarRating(
                    rating: count,
                    size: 16,
                    color: Colors.black87,
                    borderColor: AppColors.lightColorTextField,
                    filledIconData: Icons.star,
                    halfFilledIconData: Icons.star_half,
                    defaultIconData: Icons.star_border,
                    starCount: 5,
                    allowHalfRating: true,
                  ),
                ],
              )
            : Container(
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
              ));
  }
}
