import 'package:findovio/consts.dart';
import 'package:findovio/models/discover_page_keywords_list.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/providers/discover_page_filters.dart';
import 'package:findovio/screens/home/discover/provider/keywords_provider.dart';
import 'package:findovio/screens/home/discover/widgets/keyword_button.dart';
import 'package:findovio/screens/home/main_page/main/screens/Booking/screens/widgets/title_bar_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';

class SearchParameters {
  final String? keywords;
  final String? address;
  final String? radius;

  SearchParameters({this.keywords, this.address, this.radius});
}

class SearchFieldScreen extends StatefulWidget {
  final bool isKeywordSearch;
  final List<SalonModel>? salonListToTakeCities;
  final Function()? callbackFetch;
  final List<DiscoverPageKeywordsList>? keywordList;

  const SearchFieldScreen(
      {super.key,
      required this.isKeywordSearch,
      this.salonListToTakeCities,
      this.callbackFetch,
      this.keywordList});

  @override
  State<SearchFieldScreen> createState() => _SearchFieldScreenState();
}

class _SearchFieldScreenState extends State<SearchFieldScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  bool _isFetchingLocation = false;

  @override
  void initState() {
    super.initState();
    _showKeyboard();
  }

  void _fetchUserLocation() async {
    setState(() {
      _isFetchingLocation = true;
    });

    var userDataProvider =
        Provider.of<DiscoverPageFilterProvider>(context, listen: false);

    try {
      // Sprawdź, czy udzielono zgody na lokalizację
      var status = await Permission.location.request();

      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        // Pobierz informacje o lokalizacji na podstawie współrzędnych
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
          localeIdentifier: 'pl_PL',
        );

        // Pobierz miasto z informacji o lokalizacji
        String city = placemarks.first.locality ?? '';

        // Wyświetl miasto w polu tekstowym
        _textController.text = city;
        if (mounted) {
          userDataProvider.setCity(_textController.text);
          await widget.callbackFetch!();
          Get.back();
        }
      } else {
        // Obsłuż przypadek, gdy użytkownik odmówił zgody na lokalizację
      }
    } catch (e) {
      // Obsłuż błędy
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingLocation = false;
        });
      }
    }
  }

  void _showKeyboard() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_textFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<DiscoverPageFilterProvider>(context);
    final keywordProvider = Provider.of<KeywordProvider>(context);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TitleBarWithBackButton(
                  title: widget.isKeywordSearch
                      ? 'Szukaj salonów lub usług'
                      : 'Wpisz miasto lub kod pocztowy',
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      controller: _textController,
                      focusNode: _textFocusNode,
                      decoration: InputDecoration(
                        hintText:
                            widget.isKeywordSearch ? 'Słowa kluczowe' : 'Adres',
                      ),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) async {
                        if (widget.isKeywordSearch == false) {
                          await widget.callbackFetch!();
                          Get.back();
                          userDataProvider
                              .setCityWithoutNotyfing(_textController.text);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!widget.isKeywordSearch)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: _isFetchingLocation
                            ? const Color.fromARGB(255, 250, 250, 250)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: InkWell(
                        onTap: () async {
                          _fetchUserLocation();

                          // Close the search field screen
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                    Icons.location_on), // ikona lokalizacji
                                const SizedBox(
                                    width: 8), // odstęp między ikoną a tekstem
                                AnimatedOpacity(
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    opacity: _isFetchingLocation ? 0.5 : 1,
                                    child:
                                        const Text('Użyj mojej lokalizacji')),
                                const SizedBox(
                                    width:
                                        8), // odstęp między tekstem a ikoną ładowania
                              ],
                            ),
                            Positioned.fill(
                              child: Center(
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 500),
                                  opacity: _isFetchingLocation ? 0.5 : 0,
                                  child: const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black),
                                  ), // animacja ładowania),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

// Method to fetch user's location
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      if (widget.isKeywordSearch == true) {
                        _search(context);
                      }
                      if (widget.isKeywordSearch == false) {
                        // Show loading indicator for the "Szukaj" button
                        setState(() {});

                        userDataProvider.setCity(_textController.text);
                        // Perform the actual operation (callbackFetch)
                        await widget.callbackFetch!();
                        // Hide loading indicator after the operation is complete
                        setState(() {});

                        // Close the search field screen
                        Get.back();
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height * 0.05,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.orange,
                      ),
                      child: const Text(
                        'Szukaj',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  ConstsWidgets.gapH20,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      widget.isKeywordSearch == true
                          ? 'Popularne'
                          : 'Lub wybierz z listy',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 78, 78, 78),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (!widget.isKeywordSearch &&
                      widget.salonListToTakeCities != null)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Builder(
                        builder: (context) {
                          List<SalonModel>? _salonListToTakeCities =
                              widget.salonListToTakeCities;

                          if (_salonListToTakeCities == null) {
                            return const Text(
                                'brak danych'); // Replace YourNoDataWidget with your actual widget for no data
                          }
                          List<String> uniqueCities = _salonListToTakeCities
                              .map((salon) => salon.addressCity.toLowerCase())
                              .toSet()
                              .toList();

                          return Wrap(
                            spacing: 0,
                            children: uniqueCities.map((city) {
                              return GestureDetector(
                                child: KeywordButton(
                                  city: city.capitalize,
                                ),
                                onTap: () {
                                  _textController.text = city;
                                  if (widget.isKeywordSearch != true) {
                                    userDataProvider
                                        .setCity(_textController.text);
                                  }
                                },
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),

                  if (widget.isKeywordSearch)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Wrap(
                        spacing:
                            0, // Adjust the spacing between buttons as needed
                        children: keywordProvider.keywords.map((keyword) {
                          return GestureDetector(
                            child: KeywordButton(keyword: keyword),
                            onTap: () {
                              _textController.text = keyword.word;
                              if (widget.isKeywordSearch != true) {
                                userDataProvider.setCity(_textController.text);
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ));
  }

  void _search(BuildContext context) async {
    final searchText = _textController.text;
    try {
      Get.back(
        result: SearchParameters(
          keywords: widget.isKeywordSearch ? searchText : null,
          address: widget.isKeywordSearch ? null : searchText,
          radius: widget.isKeywordSearch ? null : '35',
        ),
      );
    } catch (error) {
      // Handle errors if needed
    }
  }
}
