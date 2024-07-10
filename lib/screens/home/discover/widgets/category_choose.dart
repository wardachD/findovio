import 'package:findovio/consts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:findovio/providers/discover_page_filters.dart';

class CategoryChooseWidget extends StatefulWidget {
  final List<String> uniqueCategories;
  final String selectedCat;
  const CategoryChooseWidget(
      {Key? key, required this.uniqueCategories, required this.selectedCat})
      : super(key: key);

  @override
  State<CategoryChooseWidget> createState() => _CategoryChooseWidgetState();
}

class _CategoryChooseWidgetState extends State<CategoryChooseWidget> {
  String selectedCategory = ''; // Zmienna do przechowywania wybranej kategorii.
  DiscoverPageFilterProvider userDataProvider = DiscoverPageFilterProvider();
  @override
  void initState() {
    super.initState();
    userDataProvider =
        Provider.of<DiscoverPageFilterProvider>(context, listen: false);
  }

  String selectCategory(String category) {
    if (selectedCategory == category) {
      // Jeśli już jest wybrana, odznacz ją.
      selectedCategory = '';
    } else {
      selectedCategory = category;
    }
    return selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width * 0.9,
          margin: const EdgeInsets.symmetric(horizontal: 28),
          child: const Text('kategorie',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ),
        ConstsWidgets.gapH8,
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.9,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.uniqueCategories.map((category) {
                return _buildCategoryContainer(category);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryContainer(String category) {
    final userDataProvider = Provider.of<DiscoverPageFilterProvider>(context);
    bool isSelected = userDataProvider.userData.category == category;
    return GestureDetector(
      onTap: () {
        userDataProvider.setCategoryWithoutNotifying(selectCategory(category));
        setState(() {});
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: isSelected
              ? Border.all(color: const Color.fromARGB(255, 255, 141, 33))
              : Border.all(color: const Color.fromARGB(255, 165, 165, 165)),
          color: isSelected ? Colors.white : Color.fromARGB(255, 247, 247, 247),
        ), // Dostosuj szerokość kontenera do własnych potrzeb.
        height: 40, // Dostosuj wysokość kontenera do własnych potrzeb.
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              color: isSelected ? Colors.orange : Colors.black,
              fontWeight: !isSelected ? FontWeight.normal : FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
