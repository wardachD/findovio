import 'package:findovio/consts.dart';
import 'package:findovio/controllers/bottom_app_bar_index_controller.dart';
import 'package:findovio/providers/firebase_py_user_provider.dart';
import 'package:findovio/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final String response;

  const BookingConfirmationScreen({Key? key, required this.response})
      : super(key: key);

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    Provider.of<FirebasePyUserProvider>(context, listen: false).fetchData();
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
    _controller.addListener(() {
      if (_controller.isCompleted) {
        Get.offAllNamed(Routes.HOME);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Animated progress bar
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(25)),
                    width: MediaQuery.of(context).size.width *
                        1, // Adjust the width as needed
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(50),
                          backgroundColor:
                              Colors.white, // Grey color for the progress bar
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 223, 223,
                                  223)), // Same color for progress
                          value: _animation
                              .value, // Set the current progress value
                        );
                      },
                    ),
                  ),
                ],
              ),
              // Centered Big icon with text
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      MdiIcons.checkCircle,
                      size: 120,
                      color: Colors.orange,
                      shadows: const [
                        BoxShadow(
                            color: Color.fromARGB(255, 240, 239, 239),
                            blurRadius: 5,
                            offset: Offset(2, 2))
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Super, zarezerwowane!',
                      style: TextStyle(
                        color: Color.fromARGB(255, 65, 65, 65),
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                      child: Text(
                        'Wszystko gotowe, przypomnimy Ci o wizycie.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 102, 102, 102),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                _controller.stop();

                Provider.of<FirebasePyUserProvider>(context, listen: false)
                    .fetchData();

                Get.offNamed(Routes.HOME);
                Get.find<BottomAppBarIndexController>().setBottomAppBarIndex(0);
              },
              child: Column(
                children: [
                  AnimatedContainer(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange),
                    ),
                    duration: const Duration(milliseconds: 300),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Przejdź do Moich Rezerwacji  ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(MdiIcons.arrowRight, color: Colors.white, size: 18)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => {
                Get.offAllNamed(Routes.HOME),
                Provider.of<FirebasePyUserProvider>(context, listen: false)
                    .fetchData(),
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: 45,
                child: const Text(
                  'Strona główna',
                  style: TextStyle(
                    color: Color.fromARGB(255, 59, 59, 59),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
