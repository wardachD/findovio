import 'package:findovio/consts.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/category_item.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatefulWidget {
  CategoryTile(
      {super.key,
      required this.customCategoryItem,
      this.iconHeight,
      this.textSize,
      this.isIconDisabled,
      this.fontColor});

  final CategoryItem customCategoryItem;
  double? iconHeight;
  double? textSize;
  bool? isIconDisabled;
  Color? fontColor;

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.isIconDisabled == null)
          Image.asset(widget.customCategoryItem.imagePath,
              height: widget.iconHeight ?? 25),
        if (widget.isIconDisabled == null) ConstsWidgets.gapW8,
        Text(
          widget.customCategoryItem.title,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: widget.textSize ?? 12,
              color: widget.fontColor ?? AppColors.primaryLightColorText),
        ),
      ],
    );
  }
}
