import 'package:findovio/screens/intro/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RegisterScreenNameEmail extends StatefulWidget {
  const RegisterScreenNameEmail({super.key});

  @override
  State<RegisterScreenNameEmail> createState() =>
      _RegisterScreenNameEmailState();
}

class _RegisterScreenNameEmailState extends State<RegisterScreenNameEmail> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

  var _isNameVerified = false;
  var _isEmailVerified = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.1,
              image: AssetImage('assets/images/intro_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 40),
            curve: Curves.easeIn,
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
            child: Column(
              children: [
                /// Top
                AnimatedContainer(
                  duration: const Duration(milliseconds: 40),
                  height: 60,
                ),
                AnimatedOpacity(
                  opacity: 1,
                  duration: const Duration(milliseconds: 150),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        // Szerokość obrazka
                        height: 35,
                        width: MediaQuery.sizeOf(context).width,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/logo/logo.png'), // Dopasowanie obrazka do kontenera
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedPadding(
                    padding: const EdgeInsets.fromLTRB(25, 20, 25, 25),
                    duration: const Duration(milliseconds: 250)),

                /// 'Stwórz konto'
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back),
                          Text(
                            'Cofnij',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: const Text(
                    'Stwórz konto',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),

                /// 'Wprowadź swoje dane i szukaj wśród wielu salonów',
                const Text(
                  'Wprowadź swoje dane i szukaj wśród wielu salonów',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 73, 73, 73),
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 22.0),

                /// 'Imie i nazwisko'
                Form(
                  key: formKeys[0],
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    controller: _fullNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Imię';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Imię',
                      icon: Icon(MdiIcons.humanGreetingVariant),
                      contentPadding: const EdgeInsets.all(16.0),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 255, 82, 82),
                            width: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 255, 82, 82),
                            width: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[400]!, width: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 44, 44, 44), width: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[400]!, width: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[400]!, width: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                Form(
                  key: formKeys[1],
                  child: TextFormField(
                    onTapOutside: (event) => {FocusScope.of(context).unfocus()},
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        setState(() {
                          _isEmailVerified = false;
                        });
                        return 'Adres Email jest wymagany';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value.trim())) {
                        setState(() {
                          _isEmailVerified = false;
                        });
                        return 'Nieprawidłowy format adresu Email';
                      }
                      setState(() {
                        _isEmailVerified = true;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Adres Email',
                      icon: Icon(MdiIcons.at),
                      contentPadding: const EdgeInsets.all(16.0),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 255, 82, 82),
                            width: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 255, 82, 82),
                            width: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[400]!, width: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 44, 44, 44), width: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[400]!, width: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[400]!, width: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),

                /// Button
                GestureDetector(
                  onTap: () async {
                    if (formKeys[1].currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      _isEmailVerified = true;
                      _emailController.text.replaceAll(' ', '');
                    } else {
                      _isEmailVerified = false;
                    }
                    if (formKeys[0].currentState!.validate()) {
                      _isNameVerified = true;
                    } else {
                      _isNameVerified = false;
                    }

                    if (_isEmailVerified && _isNameVerified) {
                      Get.to(RegisterScreen(
                          name: _fullNameController.text,
                          email: _emailController.text));
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.orange,
                    ),
                    child: const Text(
                      'Dalej',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height * 0.05,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: const Text(
                      'Cofnij',
                      style: TextStyle(
                        color: Color.fromARGB(255, 43, 43, 43),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
