import 'package:findovio/consts.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/salon_avatar_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:findovio/providers/firebase_py_user_provider.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';

import 'salon_list_element_await.dart';

class NearbySalons extends StatelessWidget {
  const NearbySalons({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<FirebasePyUserProvider, List<SalonModel>>(
      selector: (_, provider) =>
          provider.salons ?? [], // Replace with your logic
      builder: (context, salons, _) {
        if (salons.isEmpty) {
          return const Center(
            child: SalonListElementAwait(), // Or any loading indicator
          );
        } else {
          // Extracting all categories from all salons
          // Extracting all categories from all salons
          Set<String> uniqueCategories = {};
          for (var salon in salons) {
            uniqueCategories.add(salon.flutterCategory);
          }

          // Add "All" as the first tab
          List<Tab> tabs = uniqueCategories.map((category) {
            return Tab(text: category);
          }).toList();
          tabs.insert(0, const Tab(text: "Wszystkie kategorie"));

          // Create tab views for each category
          List<Widget> tabViews = [
            SalonAvatarList(salons: salons)
          ]; // "All" tab view
          tabViews += uniqueCategories.map((category) {
            List<SalonModel> salonsInCategory = salons.where((salon) {
              return salon.flutterCategory == category;
            }).toList();
            return SalonAvatarList(salons: salonsInCategory);
          }).toList();
          return DefaultTabController(
            length: tabs.length,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(25, 0, 0, 8),
                    child: Text(
                      'Dla Ciebie',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          letterSpacing: 0.1,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color.fromARGB(255, 22, 22, 22)),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: 35,
                  child: ButtonsTabBar(
                    buttonMargin: const EdgeInsets.only(left: 22),
                    backgroundColor: Colors.black,
                    unselectedBackgroundColor: AppColors.lightColorTextField,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    tabs: tabs,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 0.44,
                  child: Column(
                    children: [
                      Flexible(
                        child: TabBarView(
                          children: tabViews,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}



// class NearbySalons extends StatelessWidget {
//   const NearbySalons({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Selector<FirebasePyUserProvider, List<SalonModel>>(
//       selector: (_, provider) =>
//           provider.salons ?? [], // Replace with your logic
//       builder: (context, salons, _) {
//         if (salons.isEmpty) {
//           return const Center(
//             child: SalonListElementAwait(), // Or any loading indicator
//           );
//         } else {
//           return SalonAvatarList(salons: salons);
//         }
//       },
//     );
//   }
// }
