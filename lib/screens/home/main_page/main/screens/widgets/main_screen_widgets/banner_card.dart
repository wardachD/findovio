import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/video_background.dart';
import 'package:flutter/material.dart';

class BannerCard extends StatefulWidget {
  const BannerCard({super.key});

  @override
  State<BannerCard> createState() => _BannerCardState();
}

class _BannerCardState extends State<BannerCard> {
  bool _isCardVisible = true;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _isCardVisible
          ? GestureDetector(
              onTap: () {
                setState(() {
                  _isCardVisible = false; // Hide the card when tapped
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: const VideoPlayerScreen(
                            videoFilePath: 'assets/gifs/welcomebanner.mp4',
                          ),
                        ),
                      ),
                      const Positioned(
                        top: 10.0,
                        right: 30.0,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 25.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : const SizedBox()
    ]); // Empty container when the card is not visible
  }
}
