import 'package:findovio/providers/firebase_py_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:findovio/consts.dart';
import 'package:provider/provider.dart'; // Import your necessary dependencies

class AddressBottomSheet extends StatefulWidget {
  const AddressBottomSheet({super.key});

  @override
  State<AddressBottomSheet> createState() => _AddressBottomSheetState();
}

class _AddressBottomSheetState extends State<AddressBottomSheet> {
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  bool isAddressValid = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    cityController.dispose();
    streetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userDataProvider =
        Provider.of<FirebasePyUserProvider>(context, listen: false);
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
                  'Mój adres',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 20, 20, 20),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ConstsWidgets.gapH12,
                const Text(
                  'Tutaj możesz zmienić swój adres który używamy do proponowania Ci salonów. Kliknij na pole i zapisz klikając w Zmień Adres',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color.fromARGB(255, 83, 83, 83),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ConstsWidgets.gapH20,
                // TITLE BAR

                //CITY
                TextFormField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: cityController,
                  onChanged: (value) => setState(() {
                    isAddressValid = true;
                  }),
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
                  controller: streetController,
                  onChanged: (value) => isAddressValid = true,
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

                ConstsWidgets.gapH8,
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: isAddressValid
                          ? () async {
                              if (cityController.text != '') {
                                userDataProvider.user?.userCity =
                                    cityController.text;
                              }
                              if (streetController.text != '') {
                                userDataProvider.user?.userStreet =
                                    streetController.text;
                              }
                              if (streetController.text != '' &&
                                  cityController.text != '') {}

                              Navigator.pop(context);
                            }
                          : null,
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
                          return isAddressValid
                              ? Colors.white
                              : const Color.fromARGB(255, 100, 100,
                                  100); // Biały kolor tekstu, gdy hasło jest prawidłowe
                        }),
                      ),
                      child: const Text('Zmień Adres'),
                    ),
                  ],
                ),
              ],
            )));
  }
}
