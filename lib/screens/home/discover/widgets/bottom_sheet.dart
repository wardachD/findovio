import 'package:findovio/consts.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/providers/discover_page_filters.dart';
import 'package:findovio/screens/home/discover/widgets/category_choose.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String returnTitleFromProvider(String userData, String userTitle) {
  if (userData == '') {
    return userTitle;
  } else {
    return userData;
  }
}

class CustomBottomSheet extends StatefulWidget {
  final String filterOption;
  final List<SalonModel> salonList;
  final Function() callbackFetch;

  const CustomBottomSheet({
    super.key,
    required this.filterOption,
    required this.salonList,
    required this.callbackFetch,
  });

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  bool isFilterButtonPressed = false;
  bool isLoading = false;
  String selectedCat = '';
  List<String> uniqueCategories = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    uniqueCategories =
        widget.salonList.map((salon) => salon.flutterCategory).toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: <Widget>[
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 26.0, vertical: 10.0),
              width: MediaQuery.of(context).size.width * 1,
              child: Text(
                widget.filterOption,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.1,
                ),
              ),
            ),
            CategoryChooseWidget(
              uniqueCategories: uniqueCategories,
              selectedCat: selectedCat,
            ),
            ConstsWidgets.gapH16,
            const Text(
              'Filtruj',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            ConstsWidgets.gapH16,
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  // Orange background color
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Material(
                        child: InkWell(
                          splashColor: Colors.orangeAccent,
                          onTap: () => {
                            Navigator.of(context).pop(),
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.37,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color.fromARGB(255, 31, 31, 31),
                                  width: 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Cofnij',
                              style: TextStyle(
                                color: Color.fromARGB(255, 43, 43, 43),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        child: InkWell(
                          splashColor: Colors.orangeAccent,
                          onTap: () async {
                            Provider.of<DiscoverPageFilterProvider>(context,
                                    listen: false)
                                .setCategory(
                                    Provider.of<DiscoverPageFilterProvider>(
                                            context,
                                            listen: false)
                                        .userData
                                        .category);
                            await widget.callbackFetch();
                            if (mounted) {
                              Navigator.of(context).pop();
                            }
                            isFilterButtonPressed = true;
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.37,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              border:
                                  Border.all(color: Colors.orange, width: 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Filtruj',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
