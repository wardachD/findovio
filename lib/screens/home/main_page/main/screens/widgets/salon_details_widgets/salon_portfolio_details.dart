import 'package:findovio/models/salon_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'portfolio_widgets/fullscreen_image_screen.dart';

class SalonPortfolioDetails extends StatelessWidget {
  final SalonModel salon;
  const SalonPortfolioDetails({Key? key, required this.salon});

  @override
  Widget build(BuildContext context) {
    List<String>? gallery = salon.salonGallery;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: gallery != null && gallery.isNotEmpty
          ? GridView.builder(
              itemCount: gallery.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.2),
              ),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FullScreenImageScreen(
                            imageUrl: gallery![index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Image.asset(
                              'assets/gifs/background-placeholder.gif'),
                          imageUrl: gallery![index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text("Nic tu nie ma"),
            ),
    );
  }
}
