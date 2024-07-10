import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findovio/globals/no_internet_dialog.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:findovio/providers/favorite_salons_provider.dart';
import 'package:findovio/screens/chat/chat/chat_screen.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/build_icon_button.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/salon_details_widgets/salon_details.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/salon_details_widgets/salon_reviews.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'screens/widgets/salon_details_widgets/salon_portfolio_details.dart';
import 'screens/widgets/salon_details_widgets/salon_services_details.dart';

class SalonDetailsScreen extends StatefulWidget {
  const SalonDetailsScreen({Key? key}) : super(key: key);

  @override
  State<SalonDetailsScreen> createState() => _SalonDetailsScreenState();
}

class _SalonDetailsScreenState extends State<SalonDetailsScreen>
    with TickerProviderStateMixin {
  final SalonModel salonModel = Get.arguments as SalonModel;
  int previousIndex = 0;
  bool isHided = false;
  late TabController _tabController;
  ValueNotifier<double> currentOffset = ValueNotifier<double>(250.0);
  late double deltaOffset;
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  late AnimationController _positionController;
  late Animation<double> _positionAnimation;
  late Animation<double> _mapAnimation;
  late AnimationController _mapController;
  InternetStatus? _connectionStatus;
  FirebaseApp findoviobizFirebase = Firebase.app('findoviobiz');
  String _searchQuery = '';
  List<types.User> _searchResults = [];
  late StreamSubscription<InternetStatus> _subscription;
  FavoriteSalonsProvider favoriteSalonsProvider = FavoriteSalonsProvider();

  bool isTopHit = false;
  bool isBottomHit = false;

  @override
  void initState() {
    super.initState();
    _subscription = InternetConnection().onStatusChange.listen((status) {
      setState(() {
        _connectionStatus = status;
      });
    });

    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _positionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );
    _mapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );

    _heightAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut, // You can change this to your desired curve
    ).drive(Tween<double>(
      begin: 250.0,
      end: 0.0,
    ));
    _positionAnimation = CurvedAnimation(
      parent: _positionController,
      curve: Curves.easeInOut, // You can change this to your desired curve
    ).drive(Tween<double>(
      begin: _tabController.index == 3 ? 250 : 225,
      end: 0.0,
    ));
    _mapAnimation = CurvedAnimation(
      parent: _mapController,
      curve: Curves.easeInOut, // You can change this to your desired curve
    ).drive(Tween<double>(
      begin: 250.0,
      end: 0.0,
    ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _positionController.dispose();
    _subscription.cancel();
    super.dispose();
  }

  void _handleSwipe(DragEndDetails details) {
    setState(() {
      if (details.velocity.pixelsPerSecond.dx > 0) {
        if (_tabController.index > 0) {
          _tabController.animateTo(_tabController.index - 1);
        }
      } else {
        if (_tabController.index < 3) {
          _tabController.animateTo(_tabController.index + 1);
        }
      }
    });
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      if (_tabController.previousIndex == 3) {
        setState(() {
          increaseImageHeightWithAnimation();
        });
      }
      if (_tabController.index == 0) {
        if (_heightAnimation.value != 250) {
          setState(() {
            decreaseImageHeightWithAnimation();
          });
        } else {
          if (_heightAnimation.value != 0) {
            setState(() {
              increaseImageHeightWithAnimation();
            });
          }
        }
      } else if (_tabController.index <= 3) {
        increaseImageHeightWithAnimation();
      }
      if (_tabController.index == 3) {
        setState(() {
          changeMapSize(true);
          changePositionOfTopWhiteBanner(true);
        });
      } else {
        setState(() {
          changeMapSize(false);
        });
      }
    }
  }

  void changeMapSize(bool isHided) {
    if (isHided) {
      _mapController.reverse();
    } else {
      _mapController.forward();
    }
  }

  void decreaseImageHeightWithAnimation() {
    _animationController.reverse();
    _positionController.reverse();
  }

  void increaseImageHeightWithAnimation() {
    _animationController.forward();
    _positionController.forward();
  }

  void changePositionOfTopWhiteBanner(bool isHided) {
    if (isHided) {
      _positionController.reverse();
    }
    if (!isHided) {
      _positionController.forward();
    }
  }

  void _startChat() async {
    final User? user = FirebaseAuth.instance.currentUser;
    FirebaseChatCoreConfig config =
        FirebaseChatCoreConfig('findoviobiz', 'rooms', 'users');
    FirebaseChatCore.instance.setConfig(config);
    await _searchUsers('test10@test.com');
    final room =
        await FirebaseChatCore.instance.createRoom(_searchResults.first);
    Get.to(ChatScreen(room: room));
  }

  Future<void> _searchUsers(String query) async {
    final FirebaseFirestore _firestore =
        FirebaseFirestore.instanceFor(app: findoviobizFirebase);

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    // Normalizujemy zapytanie, aby wyszukiwanie było case-insensitive
    final searchKey = query.toLowerCase();

    // Tworzymy zakresy wyszukiwania dla pierwszego i ostatniego możliwego znaku
    final startKey = searchKey;
    final endKey = '$searchKey\uf8ff';

    final userQuery = await _firestore
        .collection('users')
        .where('firstName', isGreaterThanOrEqualTo: startKey)
        .where('firstName', isLessThanOrEqualTo: endKey)
        .get();

    final emailQuery = await _firestore
        .collection('users')
        .where('email', isGreaterThanOrEqualTo: startKey)
        .where('email', isLessThanOrEqualTo: endKey)
        .get();

    final users = userQuery.docs
        .map((doc) {
          final userData = doc.data();
          var userRole =
              userData['role'] == 'agent' ? types.Role.agent : types.Role.user;
          return types.User(
            id: doc.id,
            firstName: userData['firstName'],
            imageUrl: userData['imageUrl'],
            email: userData['email'],
            role: userRole,
          );
        })
        .toList()
        .cast<types.User>();

    final emailUsers = emailQuery.docs
        .map((doc) {
          final userData = doc.data();
          var userRole =
              userData['role'] == 'agent' ? types.Role.agent : types.Role.user;
          return types.User(
            id: doc.id,
            firstName: userData['firstName'],
            imageUrl: userData['imageUrl'],
            email: userData['email'],
            role: userRole,
          );
        })
        .toList()
        .cast<types.User>();

    setState(() {
      _searchResults = [...users, ...emailUsers]
          .where((element) => element.role == types.Role.agent)
          .toSet()
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus == InternetStatus.disconnected) {
      return NoInternetDialog();
    } else {
      var userDataProvider =
          Provider.of<FavoriteSalonsProvider>(context, listen: false);
      String locationString = salonModel.location;

      RegExp regExp = RegExp(r"(\d+\.\d+)");

      Iterable<RegExpMatch> matches = regExp.allMatches(locationString);

      double latitude = double.parse(matches.firstOrNull?.group(0) ?? '0');
      double longitude =
          double.parse(matches.elementAtOrNull(1)?.group(0) ?? '0');

      LatLng latLng = LatLng(latitude, longitude);

      return Scaffold(
        body: Stack(
          children: [
            DefaultTabController(
              length: 4,
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      AnimatedBuilder(
                          animation: _animationController,
                          child: const SizedBox(),
                          builder: (context, child) {
                            return CachedNetworkImage(
                              imageUrl: salonModel.avatar,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: _heightAnimation.value,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }),
                      if (_tabController.index > 1)
                        AnimatedBuilder(
                            animation: _mapAnimation,
                            builder: (context, child) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: SizedBox(
                                  height: _mapAnimation.value,
                                  child: FlutterMap(
                                    options: MapOptions(
                                      center: latLng,
                                      zoom: 13.0,
                                    ),
                                    children: [
                                      TileLayer(
                                        urlTemplate:
                                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                        subdomains: const ['a', 'b', 'c'],
                                      ),
                                      MarkerLayer(
                                        markers: [
                                          Marker(
                                            width: 80.0,
                                            height: 80.0,
                                            point: latLng,
                                            child: const Icon(
                                              Icons.location_on,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              size: 40.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      AnimatedBuilder(
                          animation: _positionAnimation,
                          builder: (_, child) {
                            return Positioned(
                              top: _tabController.index == 3
                                  ? 225
                                  : _positionAnimation.value,
                              width: MediaQuery.of(context).size.width,
                              child: Container(
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: const [
                                      BoxShadow(
                                        color:
                                            Color.fromARGB(103, 255, 255, 255),
                                        offset: Offset(0, -2),
                                        blurRadius: 12.0,
                                      )
                                    ]),
                              ),
                            );
                          }),
                      SafeArea(
                        child: Row(
                          children: [
                            buildIconButton(Icons.arrow_back, () {
                              Get.back();
                            }),
                            const Spacer(),
                            buildIconButton(MdiIcons.shareVariant, () {
                              Share.share(
                                  'Findovio\nHej, sprawdź ten salon i znajdź coś dla siebie:\n${salonModel.name}\nAdres to:\n${salonModel.addressCity}, ${salonModel.addressStreet} ${salonModel.addressNumber}.\nTelefon: ${salonModel.phoneNumber}');
                            }),
                            buildIconButton(
                              userDataProvider.salons.contains(salonModel)
                                  ? MdiIcons.heart
                                  : MdiIcons.heartOutline,
                              () {
                                if (userDataProvider.salons
                                    .contains(salonModel)) {
                                  // If salon is already a favorite, remove it
                                  userDataProvider.deleteSalon(userDataProvider
                                      .salons
                                      .indexOf(salonModel));
                                  setState(() {});
                                } else {
                                  // If salon is not a favorite, add it
                                  userDataProvider.addSalon(salonModel);
                                  setState(() {});
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: salonDetailsTitle,
                  ),
                  TabBar(
                    labelColor: Colors.black,
                    labelPadding: const EdgeInsets.all(0),
                    tabs: const [
                      Tab(text: "Usługi"),
                      Tab(text: "Opinie"),
                      Tab(text: "Portfolio"),
                      Tab(text: "Informacje"),
                    ],
                    controller: _tabController,
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 4.0,
                        color: Color.fromARGB(255, 255, 182, 73),
                      ),
                    ),
                  ),
                  Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          GestureDetector(
                            onHorizontalDragEnd: (DragEndDetails details) =>
                                _handleSwipe(details),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: SalonServicesDetails(
                                  salonModel: salonModel,
                                  callbackBottom:
                                      decreaseImageHeightWithAnimation,
                                  callbackTop: increaseImageHeightWithAnimation,
                                  callbackImageHeight:
                                      increaseImageHeightWithAnimation,
                                  callbackSetImageHeight: currentOffset),
                            ),
                          ),
                          GestureDetector(
                            onHorizontalDragEnd: (DragEndDetails details) =>
                                _handleSwipe(details),
                            child: Center(
                              child: SalonReviews(salonId: salonModel.id),
                            ),
                          ),
                          GestureDetector(
                            onHorizontalDragEnd: (DragEndDetails details) =>
                                _handleSwipe(details),
                            child: Center(
                              child: SalonPortfolioDetails(
                                salon: salonModel,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onHorizontalDragEnd: (DragEndDetails details) =>
                                _handleSwipe(details),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: SalonDetails(salonModel: salonModel),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  List<Widget> get salonDetailsTitle {
    return <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  salonModel.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 31, 31, 31),
                    fontSize: 17,
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${salonModel.addressCity}, ${salonModel.addressStreet} ${salonModel.addressNumber}',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 122, 122, 122),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Material(
                  child: InkWell(
                    splashColor: Colors.white,
                    onTap: () {
                      _startChat();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Wiadomość',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Icon(Icons.send, color: Colors.white, size: 14),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ];
  }
}
