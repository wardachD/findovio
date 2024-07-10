import 'package:findovio/screens/home/profile/widgets/profile_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:findovio/consts.dart';
// Import your necessary dependencies

class PasswordChangeBottomSheet extends StatefulWidget {
  const PasswordChangeBottomSheet({super.key});

  @override
  State<PasswordChangeBottomSheet> createState() =>
      _PasswordChangeBottomSheetState();
}

class _PasswordChangeBottomSheetState extends State<PasswordChangeBottomSheet> {
  TextEditingController controller = TextEditingController();
  TextEditingController oldPassController = TextEditingController();
  bool isPasswordValid = false;
  bool hasMinLength = false;
  bool hasDigit = false;
  bool hasSpecialChar = false;

  bool isObscured = true;

  @override
  void initState() {
    super.initState();
    oldPassController = TextEditingController();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    oldPassController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  'Zmień hasło',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 20, 20, 20),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ConstsWidgets.gapH8,
                const Text(
                  'Hasło powinno zawierać minimum:',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color.fromARGB(255, 48, 48, 48),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ConstsWidgets.gapH4,
                if (!isPasswordValid)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!hasMinLength)
                        const Row(
                          children: [
                            Icon(Icons.error_outline,
                                color: AppColors.redLigthError),
                            SizedBox(width: 5),
                            Text(
                              '6 znaków',
                              style: TextStyle(color: AppColors.redLigthError),
                            ),
                          ],
                        ),
                      if (!hasDigit)
                        const Row(
                          children: [
                            Icon(Icons.error_outline,
                                color: AppColors.redLigthError),
                            SizedBox(width: 5),
                            Text(
                              '1 cyfrę',
                              style: TextStyle(color: AppColors.redLigthError),
                            ),
                          ],
                        ),
                      if (!hasSpecialChar)
                        const Row(
                          children: [
                            Icon(Icons.error_outline,
                                color: AppColors.redLigthError),
                            SizedBox(width: 5),
                            Text(
                              '1 znak specjalny',
                              style: TextStyle(color: AppColors.redLigthError),
                            ),
                          ],
                        ),
                    ],
                  ),
                ConstsWidgets.gapH20,
                TextFormField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  enableInteractiveSelection: false,
                  controller: oldPassController,
                  obscureText: isObscured,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.lightColorTextField,
                      labelText: 'Stare hasło',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isObscured =
                                !isObscured; // Pokazanie hasła po wciśnięciu
                          });
                        },
                        child: Icon(
                          isObscured ? Icons.visibility_off : Icons.visibility,
                        ),
                      )),
                ),
                ConstsWidgets.gapH8,
                TextFormField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  enableInteractiveSelection: false,
                  controller: controller,
                  obscureText: isObscured,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.lightColorTextField,
                      labelText: 'Nowe Hasło',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isObscured =
                                !isObscured; // Pokazanie hasła po wciśnięciu
                          });
                        },
                        child: Icon(
                          isObscured ? Icons.visibility_off : Icons.visibility,
                        ),
                      )),
                  onChanged: (value) {
                    // Walidacja hasła
                    setState(() {
                      hasMinLength = value.length >= 6;
                      hasDigit = value.contains(RegExp(r'\d'));
                      hasSpecialChar =
                          value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

                      isPasswordValid =
                          hasMinLength && hasDigit && hasSpecialChar;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: isPasswordValid
                          ? () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                isObscured = true;
                              });

                              ProfileWidgets.showDialogLoading(context);

                              try {
                                final user =
                                    await FirebaseAuth.instance.currentUser;
                                final cred = EmailAuthProvider.credential(
                                  email: user!.email.toString(),
                                  password: oldPassController.text,
                                );

                                await user.reauthenticateWithCredential(cred);
                                await user.updatePassword(controller.text);

                                setState(() {
                                  isObscured = true;
                                  isPasswordValid = false;
                                  controller.clear();
                                  oldPassController.clear();
                                });
                                Navigator.pop(
                                    context); // Dismiss the CircularProgressIndicator dialog

                                await ProfileWidgets
                                    .showDialogWithTitleAndButton(
                                        context, 'Hasło zaktualizowane.', 'OK');
                              } catch (error) {
                                setState(() {
                                  isObscured = true;

                                  isPasswordValid = false;
                                  controller.clear();
                                  oldPassController.clear();
                                }); // Dismiss the CircularProgressIndicator dialog

                                if (error is FirebaseAuthException) {
                                  if (error.code == 'wrong-password') {
                                    await ProfileWidgets
                                        .showDialogWithTitleAndButton(context,
                                            'Stare hasło nieprawidłowe.', 'OK');
                                  } else {
                                    setState(() {
                                      isObscured = true;
                                      isPasswordValid = false;
                                      controller.clear();
                                      oldPassController.clear();
                                    });
                                    await ProfileWidgets
                                        .showDialogWithTitleAndButton(context,
                                            'Coś poszło nie tak.', 'OK');
                                  }
                                }

                                setState(() {
                                  isObscured = true;
                                  isPasswordValid = false;
                                  controller.clear();
                                  oldPassController.clear();
                                });
                              }
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
                          return isPasswordValid
                              ? Colors.white
                              : const Color.fromARGB(255, 100, 100,
                                  100); // Biały kolor tekstu, gdy hasło jest prawidłowe
                        }),
                      ),
                      child: const Text('Zmień Hasło'),
                    ),
                  ],
                ),
              ],
            )));
  }
}
