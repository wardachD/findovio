import 'package:findovio/models/salon_model.dart';
import 'package:findovio/routes/app_pages.dart';
import 'package:findovio/screens/home/discover/provider/animated_top_bar_provider.dart';
import 'package:findovio/screens/home/main_page/main/salon_details_screen.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/salon_details_widgets/advertisements_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../main_page/main/screens/widgets/main_screen_widgets/compact_salon_tile.dart';
import '../../main_page/main/screens/widgets/main_screen_widgets/salon_avatar.dart';

class SalonSearchList extends StatefulWidget {
  final Stream<List<SalonModel>> salonsSearchFuture;
  final bool isDistanceNeeded;
  final bool sortByDistance;
  final bool? isCompact;

  const SalonSearchList(
      {super.key,
      required this.salonsSearchFuture,
      required this.isDistanceNeeded,
      required this.sortByDistance,
      this.isCompact});

  @override
  State<SalonSearchList> createState() => _SalonSearchListState();
}

class _SalonSearchListState extends State<SalonSearchList> {
  ScrollController _scrollViewController = ScrollController();
  bool isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController();
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          Provider.of<AnimatedTopBarProvider>(context, listen: false)
              .updateField(false);
        }
      }

      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown && _scrollViewController.position.pixels < 70) {
          isScrollingDown = false;
          Provider.of<AnimatedTopBarProvider>(context, listen: false)
              .updateField(true);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _scrollViewController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SalonModel>>(
        stream: widget.salonsSearchFuture,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var salons = snapshot.data;
            if (widget.sortByDistance) {
              salons!.sort(
                  (a, b) => a.distanceFromQuery.compareTo(b.distanceFromQuery));
            } else {
              salons!.sort((a, b) => b.review.compareTo(a.review));
            }

            return AnimatedSwitcher(
              reverseDuration: const Duration(milliseconds: 500),
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeInOut,
              switchOutCurve:
                  Curves.easeInOut, // Set the duration for the switch animation
              child: salons.isNotEmpty
                  ? Column(mainAxisSize: MainAxisSize.min, children: [
                      ListView.builder(
                        shrinkWrap: false,
                        cacheExtent:
                            (MediaQuery.of(context).size.height * 0.4) *
                                salons.length,
                        physics: const BouncingScrollPhysics(),
                        key:
                            UniqueKey(), // Set a unique key to trigger the animation
                        controller: _scrollViewController,
                        itemCount: salons.length,
                        itemBuilder: (context, index) {
                          var salon = salons[index];

                          /// if i want to place some widget between output
                          // if (index == 1) {
                          //   return const AdvertisementsWidget(
                          //       optionalString: 'ss');
                          // }

                          if (widget.isDistanceNeeded) {
                            return GestureDetector(
                                onTap: () {
                                  // Navigate to SalonDetailsScreen when a salon is tapped
                                  Get.toNamed(
                                    Routes.HOME_SALON,
                                    arguments: salon,
                                  );
                                },
                                child: widget.sortByDistance
                                    ? widget.isCompact == false
                                        ? SalonAvatar(
                                            salon: salon,
                                            showDistanes: true,
                                          )
                                        : CompactSalonTile(
                                            salon: salon, showDistances: true)
                                    : widget.isCompact == false
                                        ? SalonAvatar(
                                            salon: salon,
                                            showDistanes: true,
                                          )
                                        : CompactSalonTile(
                                            salon: salon, showDistances: true));
                          }

                          if (!widget.isDistanceNeeded) {
                            return GestureDetector(
                                onTap: () {
                                  // Navigate to SalonDetailsScreen when a salon is tapped
                                  Get.toNamed(
                                    Routes.HOME_SALON,
                                    arguments: salon,
                                  );
                                },
                                child: widget.sortByDistance
                                    ? widget.isCompact == false
                                        ? SalonAvatar(
                                            salon: salon,
                                            showDistanes: false,
                                          )
                                        : CompactSalonTile(
                                            salon: salon, showDistances: false)
                                    : widget.isCompact == false
                                        ? SalonAvatar(
                                            salon: salon,
                                            showDistanes: false,
                                          )
                                        : CompactSalonTile(
                                            salon: salon,
                                            showDistances: false));
                          }
                          return const SizedBox();
                        },
                      ),
                    ])
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset('assets/images/znajdz_to.png',
                              width: MediaQuery.sizeOf(context).width * 0.9),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
            );
          }
        });
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      backgroundColor: Colors.white,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 20),
          Text('Proszę czekać...'),
        ],
      ),
    );
  }
}
