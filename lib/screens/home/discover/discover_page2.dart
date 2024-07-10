import 'dart:async';

import 'package:findovio/consts.dart';
import 'package:findovio/models/discover_page_keywords_list.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:findovio/providers/discover_page_filters.dart';
import 'package:findovio/screens/home/discover/provider/animated_top_bar_provider.dart';
import 'package:findovio/screens/home/discover/provider/keywords_provider.dart';
import 'package:findovio/screens/home/discover/provider/optional_category_provider.dart';
import 'package:findovio/screens/home/discover/widgets/salon_search_list2.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/list_of_categories.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../models/search_models/salon_search_model.dart';
import 'input_screen/search_field_screen.dart';

class DiscoverScreen2 extends StatefulWidget {
  String? optionalCategry;

  DiscoverScreen2({super.key, this.optionalCategry});

  @override
  State<DiscoverScreen2> createState() => _DiscoverScreenState2();
}

class _DiscoverScreenState2 extends State<DiscoverScreen2> {
  String _selectedDistance = '2'; // Default selected distance
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
  List<ServiceSearchModel> _services = [];
  List<SalonSearchModel> _salons = [];

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

  Future<void> _search(String query) async {
    try {
      SearchResults results = await searchSalonsAndServices(query);
      setState(() {
        _services = results.services;
        _salons = results.places;
      });
    } catch (e) {
      // Handle error
      print('Error: $e');
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

  void changeSortOption(bool value) {
    setState(() {
      _sortByDistance = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Searchbar
            // press on a keyword or a result goes to final api query
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22),
              child: SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    controller: controller,
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (_) {
                      controller.openView();
                    },
                    leading: const Icon(Icons.search),
                  );
                },
                suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
                  final query = controller.text.toLowerCase();
                  final filteredList = categoryCustomList.where((item) {
                    return item.title.toLowerCase().contains(query);
                  }).toList();

                  Widget child;

                  if (query.isEmpty || query.length < 3) {
                    // Brak zapytania, pokazuje popularne usługi
                    bool queryIsInLocalList = filteredList.any(
                        (item) => item.title.toLowerCase().contains(query));
                    bool isAnyInLocalList = filteredList.isEmpty;
                    child = Column(
                      key: UniqueKey(),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 12),
                          child: Text(
                            textAlign: TextAlign.start,
                            queryIsInLocalList
                                ? 'Popularne usługi:'
                                : 'Wyszukaj słowo kluczowe:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (isAnyInLocalList)
                          ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Color.fromARGB(255, 209, 209, 209)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(Icons.search),
                              ),
                            ),
                            title: Text(query),
                            onTap: () {
                              setState(() {
                                controller.closeView(query);
                              });
                            },
                          ),
                        ...List<Widget>.generate(filteredList.length, (index) {
                          final item = filteredList[index];
                          return ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Color.fromARGB(255, 209, 209, 209)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.asset(item.imagePath,
                                    width: 22.0, height: 22.0),
                              ),
                            ),
                            title: Text(item.title),
                            onTap: () {
                              setState(() {
                                controller.closeView(item.title);
                              });
                            },
                          );
                        }),
                      ],
                    );
                  } else {
                    // Wyszukiwanie wyników na podstawie zapytania
                    Future<void> _search(String query) async {
                      try {
                        SearchResults results =
                            await searchSalonsAndServices(query);
                        setState(() {
                          _services = results.services;
                          _salons = results.places;
                        });
                      } catch (e) {
                        // Handle error
                        print('Error: $e');
                      }
                    }

                    // Jeśli zapytanie jest zawarte w categoryCustomList, nie wysyłaj zapytania do API
                    bool queryInCategoryList = categoryCustomList.any(
                        (item) => item.title.toLowerCase().contains(query));
                    print(
                        '================ is query in category list $queryInCategoryList =============');
                    if (queryInCategoryList) {
                      _services.clear();
                      _salons.clear();
                      child = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(12.0, 12, 12, 12),
                            child: Text(
                              'Popularne usługi:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          ...List<Widget>.generate(filteredList.length,
                              (index) {
                            final item = filteredList[index];

                            return ListTile(
                              leading: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color:
                                          Color.fromARGB(255, 209, 209, 209)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(item.imagePath,
                                      width: 22.0, height: 22.0),
                                ),
                              ),
                              title: Text(item.title),
                              onTap: () async {
                                _keywordController.text = query;
                                list = await fetchSearchSalons(
                                  http.Client(),
                                  keywords: query,
                                );
                                _filteredSearchStreamController.sink.add(list);
                                filteredSearchResult = searchResult;
                                unfilteredSearchResult = searchResult;
                                setState(() {
                                  controller.closeView(query);
                                });
                              },
                            );
                          }),
                        ],
                      ); // Nic nie wyświetlaj
                    } else {
                      _search(query);
                      child = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_services.isEmpty && _salons.isEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      12.0, 12, 12, 12),
                                  child: Text(
                                    textAlign: TextAlign.start,
                                    'Wyszukaj słowo kluczowe:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              255, 209, 209, 209)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Icon(Icons.search),
                                    ),
                                  ),
                                  title: Text(query),
                                  onTap: () async {
                                    _keywordController.text = query;
                                    list = await fetchSearchSalons(
                                      http.Client(),
                                      keywords: query,
                                    );
                                    _filteredSearchStreamController.sink
                                        .add(list);
                                    filteredSearchResult = searchResult;
                                    unfilteredSearchResult = searchResult;
                                    setState(() {
                                      controller.closeView(query);
                                    });
                                  },
                                ),
                              ],
                            ),
                          if (_services.isNotEmpty) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(12.0, 12, 12, 12),
                              child: Text(
                                'Usługi:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            ..._services.map((service) => ListTile(
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              255, 209, 209, 209)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Icon(Icons.search_outlined),
                                    ),
                                  ),
                                  onTap: () async {
                                    _keywordController.text = query;
                                    list = await fetchSearchSalons(
                                      http.Client(),
                                      keywords: query,
                                    );
                                    _filteredSearchStreamController.sink
                                        .add(list);
                                    filteredSearchResult = searchResult;
                                    unfilteredSearchResult = searchResult;
                                    setState(() {
                                      controller.closeView(query);
                                    });
                                  },
                                  title: Text(service.title),
                                  // Obsługa onTap dla usług
                                )),
                          ],
                          if (_salons.isNotEmpty) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(12.0, 12, 12, 12),
                              child: Text(
                                'Salony:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            ..._salons.map((salon) => ListTile(
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              255, 209, 209, 209)),
                                    ),
                                    child: Padding(
                                      padding: salon.avatar != ''
                                          ? const EdgeInsets.all(0.0)
                                          : const EdgeInsets.all(12),
                                      child: salon.avatar != ''
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.network(
                                                salon.avatar,
                                                height: 48,
                                                width: 48,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Icon(Icons.home),
                                    ),
                                  ),
                                  onTap: () async {
                                    _keywordController.text = query;
                                    list = await fetchSearchSalons(
                                      http.Client(),
                                      keywords: query,
                                    );
                                    _filteredSearchStreamController.sink
                                        .add(list);
                                    filteredSearchResult = searchResult;
                                    unfilteredSearchResult = searchResult;
                                    setState(() {
                                      controller.closeView(query);
                                    });
                                  },
                                  title: Text(salon.name),
                                  subtitle: Text(
                                      '${salon.addressCity}, ${salon.addressStreet} ${salon.addressNumber}'),
                                  // Obsługa onTap dla salonów
                                )),
                          ],
                        ],
                      );
                    }
                  }

                  return [
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: child,
                    )
                  ];
                },
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FilterButton(
                          buttonText: 'Filtry',
                          buttonIcon: Icons.filter_list_rounded,
                          onTap: () async {},
                          isActive: false),
                      FilterButton(
                          buttonText: 'Lokalizacja',
                          buttonIcon: Icons.keyboard_arrow_down_outlined,
                          onTap: () {
                            showModalBottomSheet(
                              barrierColor: const Color.fromARGB(225, 0, 0, 0),
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                    child: Container(
                                      height: 400,
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
                          isActive: false),
                      FilterWithDropdownButton(
                          buttonText: 'Sortuj',
                          buttonIcon: Icons.keyboard_arrow_down_outlined,
                          onTap: () {},
                          callback: changeSortOption,
                          isActive: false),
                      FilterButton(
                          buttonText: 'Pokaż na mapie',
                          buttonIcon: Icons.map_rounded,
                          onTap: () {},
                          isActive: false),
                    ],
                  ),
                )),

            //   padding: AppMargins.defaultMargin,
            //   child: Column(
            //     children: [
            //       InkWell(
            //         splashColor: Colors.orangeAccent,
            //         onTap: () async {
            //           _fetchKeywords();
            //           list = await _navigateToSearchInputPage(
            //               isKeywordSearch: true);
            //           _filteredSearchStreamController.sink.add(list);
            //           filteredSearchResult = searchResult;
            //           unfilteredSearchResult = searchResult;
            //         },
            //         child: Container(
            //           padding: const EdgeInsets.fromLTRB(14.0, 0, 0, 0),
            //           height: MediaQuery.sizeOf(context).height * 0.06,
            //           decoration: BoxDecoration(
            //             color: AppColors.lightColorTextField,
            //             borderRadius: BorderRadius.circular(20.0),
            //           ),
            //           child: Row(
            //             children: [
            //               const Icon(Icons.search),
            //               const SizedBox(width: 12),
            //               Expanded(
            //                 child: Text(
            //                   _keywordController.text.isNotEmpty
            //                       ? _keywordController.text
            //                       : 'Fryzjer, paznokcie, barber...',
            //                   style: const TextStyle(
            //                       color: Color.fromARGB(255, 97, 97, 97)),
            //                 ),
            //               ),
            //               if (_keywordController.text.isNotEmpty)
            //                 IconButton(
            //                   icon: const Icon(Icons.close),
            //                   onPressed: () async {
            //                     _sortByDistance = false;
            //                     _keywordController.text = '';
            //                     _isSearchActive = false;
            //                     userDataProvider.setAllToEmpty();
            //                     //searchResult = _onTapSearch();
            //                     var listTemp = await _onTapSearch();
            //                     _filteredSearchStreamController.sink
            //                         .add(listTemp);
            //                     // filteredSearchResult = searchResult;
            //                     // unfilteredSearchResult = searchResult;
            //                   },
            //                 ),
            //             ],
            //           ),
            //         ),
            //       ),
            //       const SizedBox(height: 8),
            //     ],
            //   ),
            // ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 22.0, right: 16),
                child: SalonSearchList2(
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
    );
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

class FilterButton extends StatelessWidget {
  final String buttonText;
  final IconData? buttonIcon;
  final bool isActive;
  final Function()? onTap;
  const FilterButton(
      {super.key,
      required this.buttonText,
      required this.buttonIcon,
      required this.onTap,
      required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: buttonText != 'Pokaż na mapie' ? 1.0 : 0.3,
      child: Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 2),
          margin: buttonText == 'Filtry'
              ? EdgeInsets.fromLTRB(24, 0, 0, 6)
              : EdgeInsets.fromLTRB(12, 0, 0, 6),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: isActive
                  ? Border.all(color: AppColors.accentColor, width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 4, offset: Offset(0, 3))
              ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Material(
                child: InkWell(
                    onTap: onTap,
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(buttonText),
                        SizedBox(
                          width: 6,
                        ),
                        Icon(buttonIcon)
                      ],
                    )))),
          )),
    );
  }
}

class FilterWithDropdownButton extends StatefulWidget {
  final String buttonText;
  final IconData buttonIcon;
  final VoidCallback onTap;
  final Function(bool) callback;
  final bool isActive;

  const FilterWithDropdownButton({
    Key? key,
    required this.buttonText,
    required this.buttonIcon,
    required this.onTap,
    required this.callback,
    required this.isActive,
  }) : super(key: key);

  @override
  _FilterWithDropdownButtonState createState() =>
      _FilterWithDropdownButtonState();
}

class _FilterWithDropdownButtonState extends State<FilterWithDropdownButton> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 48,
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 2),
        margin: widget.buttonText == 'Filtry'
            ? EdgeInsets.fromLTRB(24, 0, 0, 6)
            : EdgeInsets.fromLTRB(12, 0, 0, 6),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: widget.isActive
                ? Border.all(color: AppColors.accentColor, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 4, offset: Offset(0, 3))
            ]),
        child: DropdownButton<String>(
          value: selectedOption,
          icon: Icon(widget.buttonIcon),
          iconSize: 24,
          elevation: 16,
          underline: Container(),
          padding: EdgeInsets.zero,
          hint: Text(
            'Sortuj',
            style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400),
          ),
          dropdownColor: Colors.white,
          onChanged: (String? newValue) {
            setState(() {
              switch (newValue) {
                case 'Najbliższe':
                  selectedOption = newValue;
                  widget.callback(true);
                case 'Najlepsze':
                  selectedOption = newValue;
                  widget.callback(false);
                default:
                  selectedOption = newValue;
                  widget.callback(true);
              }
            });
          },
          items: <String>['Najbliższe', 'Najlepsze']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                style: TextStyle(fontSize: 13),
                value,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
