// import 'package:findovio/models/category_card.dart';
// import 'package:findovio/models/salon_model.dart';
// import 'package:flutter/material.dart';

// class SalonCategoriesList extends StatefulWidget {
//   final Future<List<SalonModel>> salonsFuture;
//   final Future<List<SalonModel>> unfilteredSalonsFuture;
//   final Function(String, String)
//       onFilterSelected; // New argument for filtering by category and location

//   const SalonCategoriesList({
//     Key? key,
//     required this.salonsFuture,
//     required this.unfilteredSalonsFuture,
//     required this.onFilterSelected,
//   }) : super(key: key);

//   @override
//   _SalonCategoriesListState createState() => _SalonCategoriesListState();
// }

// class _SalonCategoriesListState extends State<SalonCategoriesList> {
//   Map<String, bool> selectedCategories = {};
//   String selectedCategory = ""; // Track selected category
//   String selectedLocation = ""; // Track selected location

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<SalonModel>>(
//       future: widget.unfilteredSalonsFuture,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           List<String> listOfCategories = [];
//           List<String> listOfLocations = [];

//           // Extract categories and locations from the salon data
//           for (var salon in snapshot.data!) {
//             if (!listOfCategories.contains(salon.flutterCategory)) {
//               listOfCategories.add(salon.flutterCategory);
//             }

//             if (!listOfLocations.contains(salon.location)) {
//               listOfLocations.add(salon.location);
//             }
//           }
//           return Column(
//             children: [
//               // Filter by Category
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: listOfCategories.map((category) {
//                     return GestureDetector(
//                       onTap: () {
//                         widget.onFilterSelected(category, selectedLocation);
//                         setState(() {
//                           selectedCategory = category;
//                         });
//                       },
//                       child: CategoryCard(
//                         category: category,
//                         isSelected: selectedCategory == category,
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ],
//           );
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else {
//           return const CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }
