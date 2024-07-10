import 'package:findovio/models/firebase_py_register_model.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:findovio/routes/app_pages.dart';
import 'package:findovio/screens/home/profile/widgets/profile_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SocialIcon extends StatelessWidget {
  final String socialMediaType;
  final bool enabled;

  const SocialIcon(
      {super.key, required this.socialMediaType, required this.enabled});

  String getIconPath(String socialMediaType) {
    switch (socialMediaType) {
      case 'facebook':
        return 'assets/icons/facebook.png';
      case 'google':
        return 'assets/icons/google.png';
      case 'apple':
        return 'assets/icons/apple-logo.png';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.sizeOf(context).height * 0.05,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color.fromARGB(255, 63, 63, 63))),
      child: InkWell(
        onTap: enabled
            ? () async {
                try {
                  ProfileWidgets.showDialogLoading(context);
                  var resFirebaseLogin = await signInWithGoogle();
                  if (FirebaseAuth.instance.currentUser != null) {
                    /// [User] is logged in and authorized by GoogleAccount,
                    /// [Login] process is correct
                    if (resFirebaseLogin.additionalUserInfo!.isNewUser ==
                        true) {
                      /// [User] is verified if it's first time or not,
                      /// [Login] process is correct
                      /// Register to Postgres
                      User? user = FirebaseAuth.instance.currentUser;
                      var userModel = FirebasePyRegisterModel(
                          firebaseName:
                              FirebaseAuth.instance.currentUser?.displayName,
                          firebaseEmail: user?.email,
                          firebaseUid: user?.uid);
                      var resPy = await sendPostRegisterRequest(userModel);
                      if (resPy == 'success') {
                        Get.offAllNamed(Routes.HOME);
                      } else {
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            backgroundColor: Color.fromARGB(255, 252, 92, 92),
                            content: Text("Coś nie tak, spróbuj jeszcze raz"),
                          ));
                        }
                      }
                    } else {
                      /// [User] is verified if it's first time or not,
                      /// [Firebase] It is not first time
                      /// Do not register to Postgres
                      Get.offAllNamed(Routes.HOME);
                    }
                  } else {
                    /// [User] isn't logged in, after login with google there is no sign the result about the user
                    /// [Login] process is wrong
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Color.fromARGB(255, 252, 83, 83),
                      content: Text("Coś nie tak, spróbuj się zalogować."),
                    ));
                  }
                } catch (e) {
                  /// [User] isn't logged in,
                  /// [Login] process is wrong
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Color.fromARGB(255, 255, 97, 97),
                    content: Text("Coś nie tak, spróbuj się zalogować."),
                  ));
                }
              }
            : null,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Zaloguj z'),
              const SizedBox(
                width: 6,
              ),
              Image.asset(
                getIconPath(socialMediaType),
                width: 30,
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
