import 'dart:async';

import 'package:findovio/consts.dart';
import 'package:findovio/models/category_card.dart';
import 'package:findovio/models/discover_page_keywords_list.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:findovio/providers/discover_page_filters.dart';
import 'package:findovio/screens/home/discover/provider/animated_top_bar_provider.dart';
import 'package:findovio/screens/home/discover/provider/keywords_provider.dart';
import 'package:findovio/screens/home/discover/provider/optional_category_provider.dart';
import 'package:findovio/screens/home/discover/widgets/animated_top_bar.dart';
import 'package:findovio/screens/home/discover/widgets/bottom_sheet.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/list_of_categories.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'input_screen/search_field_screen.dart';
import 'widgets/salon_search_list.dart';

class DiscoverScreen extends StatefulWidget {
  String? optionalCategry;

  DiscoverScreen({super.key, this.optionalCategry});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String _selectedDistance = '35'; // Default selected distance
  String? selectedCategory;
  String? selectedLocalizations;
  bool _sortByDistance = false;
  bool _isCompact = false;
  bool _isSearchActive = false;
  final bool _showAppbar = true;
  List<DiscoverPageKeywordsList>? keywordsList;
  KeywordProvider keywordProvider = KeywordProvider();
  final StreamController<List<SalonModel>> _filteredSearchStreamController =
      StreamController<List<SalonModel>>();

  late Future<List<SalonModel>> searchResult = Future.value([]);
  late Future<List<SalonModel>> searchResultWithFilters = Future.value([]);
  late Future<List<SalonModel>> filteredSearchResult = Future.value([]);
  late Future<List<SalonModel>> unfilteredSearchResult = Future.value([]);
  late List<SalonModel> unFilteredSearch = List.empty();
  late List<SalonModel> filteredSearch = List.empty();
  List<SalonModel> list = [];

  final TextEditingController _keywordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  late DiscoverPageFilterProvider userDataProvider =
      DiscoverPageFilterProvider();
  late OptionalCategoryProvider tempOptionalCategoryProvider =
      OptionalCategoryProvider();

  late bool _isDistanceNeeded = false;

  @override
  void initState() {
    super.initState();
    Provider.of<AnimatedTopBarProvider>(context, listen: false).setDefault();
    String tempOptionalCategory = tempOptionalCategoryProvider.optionalCategory;

    if (tempOptionalCategory != '') {
      widget.optionalCategry = tempOptionalCategory;
    }
  }

  Future<void> _fetchKeywords() async {
    keywordProvider = Provider.of<KeywordProvider>(context, listen: false);
    try {
      List<DiscoverPageKeywordsList> fetchedKeywords =
          await fetchKeywordsList(http.Client());

      // Use the setKeywords method of KeywordProvider to provide the list
      keywordProvider.setKeywords(fetchedKeywords);
    } catch (error) {
      // Handle errors if needed
    }
  }

  @override
  void didChangeDependencies() {
    // Keep the optionalCategory updated each time rebuild happen

    userDataProvider = Provider.of<DiscoverPageFilterProvider>(context);
    tempOptionalCategoryProvider =
        Provider.of<OptionalCategoryProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _keywordController.dispose();
    _addressController.dispose();
    userDataProvider.setAllToEmptyWithoutNotification();
    tempOptionalCategoryProvider.setDefault();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: AppColors.backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [],
              ),
              InkWell(
                onTap: () => showDropdownMenu(context),
                child: AnimatedTopBar(
                    context: context,
                    showAppbar: _showAppbar,
                    optionalCategry: Provider.of<OptionalCategoryProvider>(
                            context,
                            listen: false)
                        .optionalCategory),
              ),
              Container(
                padding: AppMargins.defaultMargin,
                child: Column(
                  children: [
                    InkWell(
                      splashColor: Colors.orangeAccent,
                      onTap: () async {
                        _fetchKeywords();
                        list = await _navigateToSearchInputPage(
                            isKeywordSearch: true);
                        _filteredSearchStreamController.sink.add(list);
                        filteredSearchResult = searchResult;
                        unfilteredSearchResult = searchResult;
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(14.0, 0, 0, 0),
                        height: MediaQuery.sizeOf(context).height * 0.06,
                        decoration: BoxDecoration(
                          color: AppColors.lightColorTextField,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _keywordController.text.isNotEmpty
                                    ? _keywordController.text
                                    : 'Fryzjer, paznokcie, barber...',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 97, 97, 97)),
                              ),
                            ),
                            if (_keywordController.text.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () async {
                                  _sortByDistance = false;
                                  _keywordController.text = '';
                                  _isSearchActive = false;
                                  userDataProvider.setAllToEmpty();
                                  //searchResult = _onTapSearch();
                                  var listTemp = await _onTapSearch();
                                  _filteredSearchStreamController.sink
                                      .add(listTemp);
                                  // filteredSearchResult = searchResult;
                                  // unfilteredSearchResult = searchResult;
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              if (_isSearchActive)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        InkWell(
                          key: userDataProvider.userData.city != ''
                              ? const Key('withCity')
                              : const Key('withoutCity'),
                          child: CategoryCard(
                            category: 'filtry',
                            isSelected: userDataProvider.userData.city != '' ||
                                userDataProvider.userData.category != '',
                            icon: MdiIcons.filterVariant,
                            option: 0,
                          ),
                          onTap: () {
                            showModalBottomSheet(
                              showDragHandle: true,
                              context: context,
                              builder: (BuildContext context) {
                                return CustomBottomSheet(
                                  filterOption: 'Filtry',
                                  salonList: list,
                                  callbackFetch: updateSearchResults,
                                );
                              },
                            );
                          },
                        ),
                        if (userDataProvider.userData.category != '')
                          InkWell(
                            splashColor: Colors.orangeAccent,
                            child: CategoryCard(
                              category: userDataProvider.userData.category,
                              isSelected:
                                  userDataProvider.userData.category == ''
                                      ? false
                                      : true,
                              icon: MdiIcons.close,
                              option: 3,
                              callback: () => {updateSearchResults()},
                            ),
                            onTap: () {},
                          ),
                        InkWell(
                          splashColor: Colors.orangeAccent,
                          onTap: () async {
                            await showModalBottomSheet(
                              barrierColor: const Color.fromARGB(225, 0, 0, 0),
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return FractionallySizedBox(
                                  heightFactor: 0.95,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: SearchFieldScreen(
                                        isKeywordSearch: false,
                                        salonListToTakeCities: list,
                                        callbackFetch: updateSearchResults,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: CategoryCard(
                            category: userDataProvider.userData.city == ''
                                ? 'Lokalizacja'
                                : userDataProvider.userData.city,
                            isSelected: userDataProvider.userData.city == ''
                                ? false
                                : true,
                            icon: MdiIcons.close,
                            option: 1,
                            callback: () {
                              _sortByDistance = false;
                              updateSearchResults();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  children: [
                    if (_isSearchActive)
                      if (userDataProvider.userData.city != '')
                        // [View Distance]
                        InkWell(
                          onTap: () {
                            setState(() {
                              _sortByDistance = !_sortByDistance;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.only(bottom: 5, right: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: MediaQuery.of(context).size.height * 0.045,
                            decoration: BoxDecoration(
                              color: !_sortByDistance
                                  ? AppColors.lightColorTextField
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: !_sortByDistance
                                  ? Border.all(
                                      color: AppColors.lightColorTextField,
                                    )
                                  : Border.all(color: Colors.orange),
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 1500),
                              child: Row(
                                children: [
                                  Icon(
                                    _sortByDistance
                                        ? MdiIcons.star
                                        : MdiIcons.navigationVariantOutline,
                                    size: 18,
                                  ),
                                  Text('  Najbliższe'),
                                ],
                              ),
                            ),
                          ),
                        ),
                    // [View Compact]
                    if (_isSearchActive)
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isCompact = !_isCompact;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(bottom: 5, right: 15),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: MediaQuery.of(context).size.height * 0.045,
                          decoration: BoxDecoration(
                            color: !_isCompact
                                ? AppColors.lightColorTextField
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: !_isCompact
                                ? Border.all(
                                    color: AppColors.lightColorTextField,
                                  )
                                : Border.all(color: Colors.orange),
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 1500),
                            child: Row(
                              children: [
                                Icon(
                                  _isCompact
                                      ? MdiIcons.viewCompact
                                      : MdiIcons.viewCompactOutline,
                                  size: 18,
                                ),
                                Text('  Widok kompaktowy'),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Container(
                  margin: AppMargins.defaultMargin,
                  child: SalonSearchList(
                    salonsSearchFuture: _filteredSearchStreamController.stream,
                    isDistanceNeeded: _isDistanceNeeded,
                    sortByDistance: _sortByDistance,
                    isCompact: _isCompact,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDropdownMenu(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    List<PopupMenuEntry<String>> popupMenuItems = [
      const PopupMenuItem(
        value: '', // Add a default value
        child:
            Text('Wszystkie kategorie'), // Display text for the default value
      ),
      ...categoryCustomList.map((categoryItem) {
        return PopupMenuItem(
          value: categoryItem.title,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: categoryItem.title ==
                    Provider.of<OptionalCategoryProvider>(context,
                            listen: false)
                        .optionalCategory
                ? BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  )
                : null,
            child: Row(
              children: [
                Image.asset(
                  categoryItem.imagePath,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8),
                Text(categoryItem.title),
              ],
            ),
          ),
        );
      }),
    ];
    // Show the dropdown menu anchored to the widget's position
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          overlay.localToGlobal(Offset.zero),
          overlay.localToGlobal(overlay.size.bottomRight(Offset.zero)),
        ),
        Offset.zero & overlay.size,
      ),
      items: popupMenuItems,
      elevation: 8,
    ).then((value) {
      if (value != null) {
        setState(() {
          Provider.of<OptionalCategoryProvider>(context, listen: false)
              .updateField(value);
        });
        // Perform actions based on the selected value
      }
    });
  }

  Future<List<SalonModel>> _navigateToSearchInputPage(
      {required bool isKeywordSearch}) async {
    final searchParams = await Get.to<SearchParameters>(
      () => SearchFieldScreen(
        isKeywordSearch: isKeywordSearch,
      ),
    );
    String tempOptionalCategory =
        Provider.of<OptionalCategoryProvider>(context, listen: false)
            .optionalCategory;

    if (searchParams != null) {
      String? keywords;
      String? address;
      String? radius;

      if (!isKeywordSearch) {
        address = searchParams.address;
        radius = searchParams.radius ?? '25';
        keywords = _keywordController.text;
        _isDistanceNeeded = true;
        _addressController.text = address ?? '';
        _selectedDistance = radius;
      } else {
        address = _addressController.text;
        radius = _selectedDistance;
        keywords = searchParams.keywords;
        _isDistanceNeeded = false;
        _keywordController.text = keywords ?? '';
      }

      if (keywords != "" && address != "") {
        if (tempOptionalCategory != '') {
          setState(() {
            _isSearchActive = true;
          });
          return fetchSearchSalons(http.Client(),
              keywords: keywords,
              address: address,
              radius: radius,
              category: tempOptionalCategory);
        }
        setState(() {
          _isSearchActive = true;
        });
        // Send the API request with both keywords and address
        return fetchSearchSalons(http.Client(),
            keywords: keywords, address: address, radius: radius);
      } else if (keywords != "") {
        if (tempOptionalCategory != '') {
          setState(() {
            _isSearchActive = true;
          });
          return fetchSearchSalons(http.Client(),
              keywords: keywords, category: tempOptionalCategory);
        }
        setState(() {
          _isSearchActive = true;
        });
        // Send the API request with keywords only
        return fetchSearchSalons(http.Client(), keywords: keywords);
      } else if (address != "") {
        setState(() {
          _isSearchActive = true;
        });
        if (tempOptionalCategory != '') {
          setState(() {
            _isSearchActive = true;
          });
          return fetchSearchSalons(http.Client(),
              address: address, radius: radius, category: tempOptionalCategory);
        }
        // Send the API request with address only
        return fetchSearchSalons(http.Client(),
            address: address, radius: radius);
      } else {
        setState(() {
          _isSearchActive = true;
        });
        // Return an empty list if both keywords and address are null
        return fetchSearchSalons(http.Client(), category: tempOptionalCategory);
      }
    } else {
      setState(() {
        _isSearchActive = false;
      });
      // Return an empty list if searchParams is null
      return [];
    }
  }

  Future<List<SalonModel>> _onTapSearch() {
    final keywords = _keywordController.text;
    final address = userDataProvider.userData.city;
    final radius = _selectedDistance;
    _isDistanceNeeded = false;
    String tempOptionalCategory =
        Provider.of<OptionalCategoryProvider>(context, listen: false)
            .optionalCategory;
    if (keywords.isNotEmpty) {
      if (address.isNotEmpty) {
        _isDistanceNeeded = true;
        // Send the API request with both keywords and address
        if (tempOptionalCategory != '') {
          return fetchSearchSalons(http.Client(),
              keywords: keywords,
              address: address,
              radius: radius,
              category: tempOptionalCategory);
        }
        return fetchSearchSalons(http.Client(),
            keywords: keywords, address: address, radius: radius);
      } else {
        _isDistanceNeeded = false;
        // Send the API request with keywords only
        if (widget.optionalCategry != '') {
          return fetchSearchSalons(http.Client(),
              keywords: keywords, category: tempOptionalCategory);
        }
        return fetchSearchSalons(
          http.Client(),
          keywords: keywords,
        );
      }
    } else if (address.isNotEmpty) {
      _isDistanceNeeded = true;
      // Send the API request with address only
      if (widget.optionalCategry != '') {
        return fetchSearchSalons(http.Client(),
            address: address, radius: radius, category: tempOptionalCategory);
      }
      return fetchSearchSalons(http.Client(), address: address, radius: radius);
    } else {
      // Both keywords and address are empty, return an empty list
      return Future.value([]);
    }
  }

  Future<List<SalonModel>> filteredList(
      Future<List<SalonModel>> searchSalonList) async {
    dynamic salonList;
    searchSalonList.then((value) => salonList);
    return Future.value(searchSalonList);
  }

  void updateSearchResults() async {
    var searchResultNoFilter = await _onTapSearch();
    filteredSearch = searchResultNoFilter.where((result) {
      return result.flutterGender.contains(userDataProvider.userData.gender) &&
          result.flutterCategory.contains(userDataProvider.userData.category);
    }).toList();
    _filteredSearchStreamController.sink.add(filteredSearch);
  }
}
