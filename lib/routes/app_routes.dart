// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
// Intro
  static const INTRO_test = '/intro_test/';

  static const INTRO = '/intro';
  static const INTRO_SIGN = '/intro/login_or_register';
  static const INTRO_LOGIN = '/intro/login_or_register/login';
  static const INTRO_REGISTER_EMAIL_NAME =
      '/intro/login_or_register/register_email_name';
  static const INTRO_REGISTER = '/intro/login_or_register/register';
// Home
  static const HOME = '/home';
  static const HOME_SALON = '/home/salon';
// Discover
  static const DISCOVER = '/discover';
  static const DISCOVER_SEARCH = '/discover_search';
  static const DISCOVER_SEARCH_ADDRESS = '/discover_search_address';
// Appointments
  static const APPOINTMENTS = '/appointments';
  static const APPOINTMENTS_SELECTED = '/appointments/selected_appointment';
// Profile
  static const PROFILE = '/profile';
// No internet
  static const NO_INTERNET = '/no_internet';
}
