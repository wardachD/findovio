import 'package:findovio/screens/chat/chat/chat_list_screen.dart';
import 'package:findovio/screens/home/appointments/appointments_screen.dart';
import 'package:findovio/screens/home/discover/discover_page.dart';
import 'package:findovio/screens/home/discover/discover_page2.dart';
import 'package:findovio/screens/home/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/bottom_app_bar_index_controller.dart';
import 'main/main_screen.dart';
import 'widgets/bottom_app_bar.dart';

class HomeScreen extends GetView<BottomAppBarIndexController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomAppBar(),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Obx(() {
              return _getSelectedPage(controller.activeIndex.value);
            }),
          ),
        ),
      ),
    );
  }

  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        controller.optionalCategory.value = '';
        return const MainScreen();
      case 1:
        return DiscoverScreen2();
      case 2:
        controller.optionalCategory.value = '';
        return const AppointmentsScreen();
      case 3:
        controller.optionalCategory.value = '';
        return ChatListScreen();
      case 4:
        controller.optionalCategory.value = '';
        return const ProfileScreen();
      default:
        controller.optionalCategory.value = '';
        return const MainScreen();
    }
  }
}
