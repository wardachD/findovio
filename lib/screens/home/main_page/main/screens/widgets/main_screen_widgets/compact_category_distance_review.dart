import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/category_tile.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/list_of_categories.dart';
import 'package:flutter/material.dart';

class CompactCategoryDistanceReview extends StatefulWidget {
  final String categoryName;
  final num distance;
  final double review;
  final bool showDistances;

  const CompactCategoryDistanceReview({
    super.key,
    required this.categoryName,
    required this.distance,
    required this.review,
    required this.showDistances,
  });

  @override
  State<CompactCategoryDistanceReview> createState() =>
      _CompactCategoryDistanceReviewState();
}

class _CompactCategoryDistanceReviewState
    extends State<CompactCategoryDistanceReview> {
  int categoryOption = 0;

  @override
  Widget build(BuildContext context) {
    switch (widget.categoryName) {
      case 'Hairdresser':
        categoryOption = 0;
        break;
      case 'Nails':
        categoryOption = 1;
        break;
      case 'Massage':
        categoryOption = 2;
        break;
      case 'Barber':
        categoryOption = 3;
        break;
      case 'Makeup':
        categoryOption = 4;
        break;
      case 'Pedicure':
        categoryOption = 5;
        break;
      case 'Manicure':
        categoryOption = 6;
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Category
        CategoryTile(
          customCategoryItem: categoryCustomList[categoryOption],
          iconHeight: 18,
          textSize: 12,
          isIconDisabled: true,
          fontColor: const Color.fromARGB(255, 68, 68, 68),
        ),

        // Review and Distance
      ],
    );
  }
}
