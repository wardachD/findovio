import 'package:findovio/providers/api_service.dart';
import 'package:findovio/providers/firebase_py_user_provider.dart';
import 'package:findovio/screens/home/discover/widgets/gender_choose.dart';
import 'package:findovio/screens/home/profile/widgets/profile_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:findovio/consts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PersonalInfoBottomSheet extends StatefulWidget {
  const PersonalInfoBottomSheet({super.key});

  @override
  State<PersonalInfoBottomSheet> createState() =>
      _PersonalInfoBottomSheetState();
}

class _PersonalInfoBottomSheetState extends State<PersonalInfoBottomSheet> {
  TextEditingController displayNamecontroller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  bool isPasswordValid = false;
  bool hasMinLength = false;
  bool hasDigit = false;
  bool hasSpecialChar = false;
  bool isObscured = true;

  @override
  void dispose() {
    displayNamecontroller.dispose();
    cityController.dispose();
    streetController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userDataProvider =
        Provider.of<FirebasePyUserProvider>(context, listen: false);
    var user = FirebaseAuth.instance.currentUser;
    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.fromLTRB(25, 6, 25, 15),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE BAR
                const Text(
                  'Dane Osobiste',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 20, 20, 20),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ConstsWidgets.gapH12,
                const Text(
                  'Kliknij na pole które chcesz zmienić i zapisz przyciskiem Zmień Dane',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color.fromARGB(255, 83, 83, 83),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ConstsWidgets.gapH20,
                // TITLE BAR

                //DISPLAY NAME
                TextFormField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: displayNamecontroller,
                  decoration: InputDecoration(
                    suffixText: 'Imię i nazwisko',
                    suffixIcon: const Icon(Icons.edit),
                    filled: true,
                    fillColor: AppColors.lightColorTextField,
                    labelText: userDataProvider.user!.firebaseName,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                ConstsWidgets.gapH8,
                //DISPLAY NAME

                //CITY
                TextFormField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: cityController,
                  decoration: InputDecoration(
                    suffixText: 'Miasto',
                    suffixIcon: const Icon(Icons.edit),
                    filled: true,
                    fillColor: AppColors.lightColorTextField,
                    labelText: userDataProvider.user!.userCity ?? 'Miasto',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                ConstsWidgets.gapH8,
                //CITY

                //ULICA
                TextFormField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: streetController,
                  decoration: InputDecoration(
                    suffixText: 'Ulica',
                    suffixIcon: const Icon(Icons.edit),
                    filled: true,
                    fillColor: AppColors.lightColorTextField,
                    labelText: userDataProvider.user!.userStreet ?? 'Ulica',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                ConstsWidgets.gapH8,
                //ULICA

                //NUMER TELEFONU
                TextFormField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    suffixText: 'Numer Telefonu',
                    suffixIcon: const Icon(Icons.edit),
                    filled: true,
                    fillColor: AppColors.lightColorTextField,
                    labelText: userDataProvider.user!.userPhoneNumber ??
                        'Numer telefonu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                ConstsWidgets.gapH8,
                //NUMER TELEFONU

                //EMAIL
                TextFormField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: emailController,
                  decoration: InputDecoration(
                    enabled: false,
                    suffixText: 'Adres Email',
                    filled: true,
                    fillColor: AppColors.lightColorTextField,
                    labelText:
                        userDataProvider.user?.firebaseEmail ?? 'Adres Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                ConstsWidgets.gapH8,
                //EMAIL

                //PŁEĆ
                GenderChooseWidget(
                  customTitle: 'Płeć',
                  customSelection: userDataProvider.user?.userGender,
                ),
                //PŁEĆ

                ConstsWidgets.gapH8,
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (displayNamecontroller.text != '' &&
                            userDataProvider.user != null) {
                          if (displayNamecontroller.text.length > 17) {
                            ProfileWidgets.showDialogWithTitleAndButton(
                                context, 'Podane imie jest zbyt długie', 'OK');
                            return;
                          }
                          ProfileWidgets.showDialogLoading(context);

                          try {
                            userDataProvider.user?.firebaseName =
                                displayNamecontroller.text;
                            await user!
                                .updateDisplayName(displayNamecontroller.text);
                            var result = await changeFirebasePyUser(
                                http.Client(),
                                displayNamecontroller.text,
                                userDataProvider.user!.id.toString());
                            print(result);

                            await ProfileWidgets.showDialogWithTitleAndButton(
                                context, 'Dane zaktualizowane.', 'OK');
                          } catch (error) {
                            await ProfileWidgets.showDialogWithTitleAndButton(
                                context,
                                'Ups... coś poszło nie tak: $error',
                                'OK');
                          }
                        }
                        if (phoneNumberController.text != '') {
                          userDataProvider.user?.userPhoneNumber =
                              phoneNumberController.text;
                        }
                        if (cityController.text != '') {
                          userDataProvider.user?.userCity = cityController.text;
                        }
                        if (streetController.text != '') {
                          userDataProvider.user?.userStreet =
                              streetController.text;
                        }
                        if (genderController.text != '') {
                          userDataProvider.user?.userGender =
                              genderController.text;
                        }
                        userDataProvider.update();
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.disabled)) {
                            return AppColors
                                .lightColorTextField; // Wyszarzony domyślny kolor
                          } else if (states.contains(MaterialState.pressed) ||
                              states.contains(MaterialState.hovered)) {
                            return Colors.orangeAccent.withOpacity(
                                0.8); // Kolor gdy naciśnięty/hovered
                          }
                          return Colors.orangeAccent; // Domyślny kolor
                        }),
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                          return isPasswordValid
                              ? Colors.white
                              : const Color.fromARGB(255, 100, 100,
                                  100); // Biały kolor tekstu, gdy hasło jest prawidłowe
                        }),
                      ),
                      child: const Text('Zmień Dane'),
                    ),
                  ],
                ),
              ],
            )));
  }
}
