import 'package:findovio/consts.dart';
import 'package:findovio/screens/intro/widgets/intro_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';

class LoginOrRegisterScreen extends StatelessWidget {
  const LoginOrRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/intro_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Image.asset(
                      'assets/images/loginregister.png',
                      width: MediaQuery.sizeOf(context).width * 0.6,
                    ),
                    ConstsWidgets.gapH20,
                    ConstsWidgets.gapH20,
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: const Text('Z kontem możesz więcej',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22.0)),
                    ),
                    ConstsWidgets.gapH8,
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 25),
                      child: Text(
                          'nowa stylistka, masaż lub wiele innych już na Ciebie czeka',
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
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IntroButton(
                    text: 'Załóż konto',
                    backgroundColor: const Color.fromARGB(55, 255, 255, 255),
                    textColor: const Color.fromARGB(255, 61, 61, 61),
                    onPressed: () => {
                      Get.toNamed(Routes.INTRO_REGISTER_EMAIL_NAME),
                    },
                  ),
                  IntroButton(
                    text: 'Zaloguj się',
                    backgroundColor: const Color.fromARGB(255, 31, 31, 31),
                    textColor: Colors.white,
                    onPressed: () => {
                      Get.toNamed(Routes.INTRO_LOGIN),
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
