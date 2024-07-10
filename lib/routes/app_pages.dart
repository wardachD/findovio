import 'package:findovio/screens/home/main_page/main/salon_details_screen.dart';
import 'package:findovio/screens/intro/register_screen_name_email.dart';
import 'package:findovio/screens/intro_test/intro_3pages_screen.dart';
import 'package:findovio/screens/unknown_route/internet_dialog.dart';
import 'package:get/get.dart';

// Intro
import 'package:findovio/screens/intro/intro_screen.dart';
import 'package:findovio/screens/intro/login_or_register_screen.dart';
import 'package:findovio/screens/intro/login_screen.dart';
import 'package:findovio/screens/intro/register_screen.dart';

// Home
import 'package:findovio/binding/home_binding.dart';
import 'package:findovio/screens/home/main_page/home_screen.dart';

// Discover
import 'package:findovio/screens/home/discover/discover_page.dart';
import 'package:findovio/screens/home/discover/input_screen/search_field_screen.dart';

// Appointments
import 'package:findovio/screens/home/appointments/appointments_screen.dart';

// Profile
import 'package:findovio/screens/home/profile/profile_screen.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.INTRO_test, page: () => const IntroScreen()),
    GetPage(name: Routes.INTRO, page: () => const Intro3PagesScreen()),
    GetPage(name: Routes.INTRO_SIGN, page: () => const LoginOrRegisterScreen()),
    GetPage(name: Routes.INTRO_LOGIN, page: () => const LoginScreen()),
    GetPage(
        name: Routes.INTRO_REGISTER_EMAIL_NAME,
        page: () => RegisterScreenNameEmail()),
    GetPage(
        name: Routes.INTRO_REGISTER,
        page: () => const RegisterScreen(
              email: '',
              name: '',
            )),
    GetPage(
        name: Routes.HOME,
        page: () => const HomeScreen(),
        binding: HomeBinding()),
    GetPage(
      name: Routes.HOME_SALON,
      page: () => const SalonDetailsScreen(),
    ),
    GetPage(name: Routes.DISCOVER, page: () => DiscoverScreen()),
    GetPage(name: Routes.APPOINTMENTS, page: () => const AppointmentsScreen()),
    GetPage(name: Routes.PROFILE, page: () => const ProfileScreen()),
    GetPage(
        name: Routes.DISCOVER_SEARCH,
        page: () => const SearchFieldScreen(
              isKeywordSearch: true,
            )),
    GetPage(name: Routes.NO_INTERNET, page: () => const InternetAlertDialog()),
  ];
}
