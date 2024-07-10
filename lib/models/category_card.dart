import 'package:findovio/consts.dart';
import 'package:findovio/providers/discover_page_filters.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CategoryCard extends StatelessWidget {
  final String category;
  final bool isSelected;
  final IconData icon;
  final int option;
  final VoidCallback? callback;

  const CategoryCard({
    required this.category,
    required this.isSelected,
    required this.icon,
    required this.option,
    this.callback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<DiscoverPageFilterProvider>(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 100),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: Container(
        key: ValueKey<bool>(isSelected),
        alignment: Alignment.center,
        margin: const EdgeInsets.only(left: 8, bottom: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height * 0.045,
        decoration: BoxDecoration(
          color: !isSelected ? AppColors.lightColorTextField : Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: !isSelected
              ? Border.all(
                  color: AppColors.lightColorTextField,
                )
              : Border.all(color: Colors.orange),
        ),
        child: Row(
          children: [
            if (isSelected || category == "filtry")
              GestureDetector(
                onTap: () async {
                  if (option == 1) {
                    userDataProvider.setCity('');
                    callback!();
                  }
                  if (option == 3) {
                    userDataProvider.setCategory('');
                    callback!();
                  }
                },
                child: Icon(icon, size: 18),
              ),
            if (isSelected || category == "filtry") const SizedBox(width: 10),
            Text('${category.capitalize}'),
          ],
        ),
      ),
    );
  }
}
