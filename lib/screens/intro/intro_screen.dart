import 'package:findovio/consts.dart';
import 'package:flutter/material.dart';
import 'package:findovio/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool _isNavigating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _isNavigating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/intro_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 350),
          opacity: _isNavigating ? 0 : 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Image.asset(
                        'assets/images/splash_login.png',
                        width: MediaQuery.sizeOf(context).width * 0.7,
                      ),
                      ConstsWidgets.gapH20,
                      ConstsWidgets.gapH20,
                      const Text('Zarezerwuj w kilka chwil i oszczędź czas',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22.0)),
                      ConstsWidgets.gapH8,
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 25),
                        child: Text(
                            'Zarezerwuj w dowolnym momencie i salonie za pomocą kilku kliknięć i skorzystaj z usług',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Color.fromARGB(255, 61, 61, 61),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: const Text(
                        'Zaloguj się',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Color.fromARGB(255, 61, 61, 61),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _isNavigating = true;
                        });
                        Future.delayed(const Duration(milliseconds: 350), () {
                          setState(() {
                            _isNavigating = false;
                          });
                          Get.toNamed(Routes.INTRO_LOGIN);
                        });
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 31, 31, 31),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Icon(
                          MdiIcons.arrowRight,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () => {
                        setState(() {
                          _isNavigating = true;
                        }),
                        Future.delayed(const Duration(milliseconds: 350), () {
                          setState(() {
                            _isNavigating = false;
                          });
                          Get.toNamed(Routes.INTRO_SIGN);
                        }),
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
