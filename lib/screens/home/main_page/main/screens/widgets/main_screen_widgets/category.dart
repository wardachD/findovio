import 'package:findovio/consts.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/category_tile.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/list_of_categories.dart';
import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  final String categoryName;

  Category({
    super.key,
    required this.categoryName,
  });

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  int categoryOption = 0;

  @override
  Widget build(BuildContext context) {
    switch (widget.categoryName) {
      case 'Fryzjer':
        categoryOption = 0;
        break;
      case 'Paznokcie':
        categoryOption = 1;
        break;
      case 'Masaż':
        categoryOption = 2;
        break;
      case 'Barber':
        categoryOption = 3;
        break;
      case 'Makijaż':
        categoryOption = 4;
        break;
      case 'Pielęgnacja stóp':
        categoryOption = 5;
        break;
      case 'Pielęgnacja dłoni':
        categoryOption = 6;
        break;
    }

    return Row(children: [
      Container(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color.fromARGB(255, 180, 180, 180)),
          color: AppColors.lightColorTextField,
        ),
        child: CategoryTile(
          customCategoryItem: categoryCustomList[categoryOption],
          iconHeight: 18,
          textSize: 12,
        ),
      ),
    ]);
  }
}
