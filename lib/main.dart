import 'package:findovio/consts.dart';
import 'package:findovio/controllers/user_data_provider.dart';
import 'package:findovio/dependency_injection.dart';
import 'package:findovio/providers/advertisements_provider.dart';
import 'package:findovio/providers/discover_page_filters.dart';
import 'package:findovio/providers/favorite_salons_provider.dart';
import 'package:findovio/providers/findovio_biz_instance.dart';
import 'package:findovio/providers/firebase_py_user_provider.dart';
import 'package:findovio/screens/home/discover/provider/animated_top_bar_provider.dart';
import 'package:findovio/screens/home/discover/provider/keywords_provider.dart';
import 'package:findovio/screens/home/discover/provider/optional_category_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:findovio/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// [Main] function of the app
void main() async {
  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();
  // Splash
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
// Firebase moved from main thread
  await initializeFirebase();
  // FCM
  if (!GetPlatform.isWeb) {
    await notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channelHigh);
    await notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channelAd);
    await notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channelLow);
    await notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(defaultChannel);
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark, // dark text for status bar
      statusBarColor: Colors.transparent));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserDataProvider(),
        ),
        ChangeNotifierProvider(create: (context) => FirebasePyUserProvider()),
        ChangeNotifierProvider(
            create: (context) => DiscoverPageFilterProvider()),
        ChangeNotifierProvider(
          create: (context) => AdvertisementProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoriteSalonsProvider(),
        ),

        // Discover page
        // Keywords
        ChangeNotifierProvider(create: (_) => KeywordProvider()),
        // Animation
        ChangeNotifierProvider(
          create: (context) => AnimatedTopBarProvider(),
        ),
        // Optional category
        ChangeNotifierProvider(
          create: (context) => OptionalCategoryProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );

  DependencyInjection.init();
  FlutterNativeSplash.remove();
}

/// [Firebase] notifications
///
/// There is default channel ovveriden to make it maximum quiet
/// to do not show it double

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final FlutterLocalNotificationsPlugin notificatons =
      FlutterLocalNotificationsPlugin();

  print('x');
  AndroidNotification android;

  print('x');
  AppleNotification ios;

  print('x');
  if (GetPlatform.isIOS) {
  } else {
    android = message.data["android"];

    if (message.data != null) {
      print('x');
      notificatons.show(
          message.data.hashCode,
          message.data["title"],
          message.data["body"],
          message.data["title"] == "Aktualizacja"
              ?

              /// [AndroidNotification] Powiadomienia aktualizacji
              /// fcm channel config: [high_importance_channel]
              NotificationDetails(
                  android: AndroidNotificationDetails(
                  channelHigh.id,
                  channelHigh.name,
                  importance: Importance.max,
                  sound: const RawResourceAndroidNotificationSound('sound'),
                  playSound: true,
                ))

              /// [AndroidNotification] inne aktualizacji
              /// fcm channel config: [high_importance_channel_ad]
              : NotificationDetails(
                  android: AndroidNotificationDetails(
                  channelAd.id,
                  channelAd.name,
                  importance: Importance.max,
                  sound: const RawResourceAndroidNotificationSound('sound'),
                  playSound: true,
                )));
    }
    print('x');
  }
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseApp secondaryApp = await FindovioBizInstance.getInstance();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');
  final FCMToken = await messaging.getToken();
  print('User token: $FCMToken');
}

AndroidNotificationChannel channelHigh = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'Ważne powiadomienia', // title
  description:
      'Te powiadomienia pokazują najważniejsze wydarzenia', //description
  importance: Importance.high,
  sound: RawResourceAndroidNotificationSound('sound'),
  playSound: true,
);

AndroidNotificationChannel channelAd = const AndroidNotificationChannel(
  'high_importance_channel_ad', // id
  'Oferty', // title
  description: 'Wyświetlanie ofert', //description
  importance: Importance.high,
  sound: RawResourceAndroidNotificationSound('sound'),
  playSound: true,
);

AndroidNotificationChannel channelLow = const AndroidNotificationChannel(
  'low_importance_channel', // id
  'Aktualizacje', // title
  description: 'Wyświetlanie ofert', //description
  importance: Importance.defaultImportance,
  playSound: false,
);

AndroidNotificationChannel defaultChannel = const AndroidNotificationChannel(
  'default_channel', // id
  'default Notifications', // title
  importance: Importance.none,
  playSound: false,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider =
        Provider.of<FirebasePyUserProvider>(context, listen: false);
    var userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        FlutterNativeSplash.remove();
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data != null) {
            snapshot.data?.reload();
          }
          final bool isLoggedIn = snapshot.hasData;
          final initialRoute = isLoggedIn ? Routes.HOME : Routes.INTRO;

          // Get the user UID if available
          getAvailableUserPyUid(
              isLoggedIn, snapshot, userProvider, userDataProvider);

          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            getPages: AppPages.pages,
            title: 'findovio',
            theme: ThemeData(
              scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
              colorScheme: ColorScheme.fromSeed(
                  surfaceTint: AppColors.lightColorTextField,
                  seedColor: const Color.fromARGB(255, 255, 255, 255)),
              useMaterial3: true,
              fontFamily: 'NotoSans',
            ),
            initialRoute: initialRoute,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<void> getAvailableUserPyUid(
      bool isLoggedIn,
      AsyncSnapshot<User?> snapshot,
      FirebasePyUserProvider userProvider,
      UserDataProvider userDataProvider) async {
    if (isLoggedIn) {
      final userUid = snapshot.data?.uid;
      if (userUid != null) {
        userProvider.setUserUid(userUid);
      }
      userDataProvider.setUserUid(userUid!);
    }
  }
}
