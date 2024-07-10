import 'package:animated_introduction/animated_introduction.dart';
import 'package:findovio/routes/app_pages.dart';
import 'package:findovio/screens/intro_test/widgets/intro_pages_collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Intro3PagesScreen extends StatelessWidget {
  const Intro3PagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedIntroduction(
          footerBgColor: Color.fromARGB(255, 255, 255, 255),
          activeDotColor: const Color.fromARGB(255, 110, 110, 110),
          inactiveDotColor: const Color.fromARGB(255, 153, 153, 153),
          topHeightForFooter: MediaQuery.sizeOf(context).height * 0.68,
          slides: pages,
          doneText: 'Zaloguj',
          indicatorType: IndicatorType.line,
          onDone: () {
            Get.toNamed(Routes.INTRO_LOGIN);
          },
          onRegister: () {
            Get.toNamed(Routes.INTRO_REGISTER_EMAIL_NAME);
          },
        ),
      ),
    );
  }
}
