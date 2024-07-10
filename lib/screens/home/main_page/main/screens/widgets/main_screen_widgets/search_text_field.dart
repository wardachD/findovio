import 'package:findovio/consts.dart';
import 'package:findovio/controllers/bottom_app_bar_index_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.find<BottomAppBarIndexController>().setBottomAppBarIndex(1);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.lightColorTextField,
        ),
        padding:
            const EdgeInsets.all(14.0), // You can adjust the padding as needed
        child: const Row(
          children: [
            Icon(Icons.search), // Icon for search
            SizedBox(width: 12), // Adjust the space between icon and text
            Text(
              'Szukaj salonu, stylisty lub usługę',
              style: TextStyle(color: Color.fromARGB(255, 97, 97, 97)),
            ),
          ],
        ),
      ),
    );
  }
}
