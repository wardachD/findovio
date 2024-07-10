import 'dart:async';

import 'package:findovio/models/advertisement_model.dart';
import 'package:findovio/models/discover_page_keywords_list.dart';
import 'package:findovio/models/findovio_advertisement_model.dart';
import 'package:findovio/models/firebase_py_get_model.dart';
import 'package:findovio/models/firebase_py_register_model.dart';
import 'package:findovio/models/salon_reviews_model.dart';
import 'package:findovio/models/salon_schedule.dart';
import 'package:findovio/models/salon_working_hours.dart';
import 'package:findovio/models/user_appointment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:findovio/consts.dart';
import 'package:findovio/models/salon_model.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../models/search_models/salon_search_model.dart';

InternetStatus? _connectionStatus;
late StreamSubscription<InternetStatus> _subscription;

void checkInternetConnection() {
  _subscription = InternetConnection().onStatusChange.listen((status) {
    _connectionStatus = status;
  });
}

void cancelInternetConnectionCheck() {
  _subscription.cancel();
}

/// [NO NEED]token secured
/// API's for advertisements
///
///
/// token [+]
Future<FindovioAdvertisement> fetchFindovioAdvertisement(
    http.Client client) async {
  try {
    bool isConnected = await InternetConnection().hasInternetAccess;

    if (isConnected) {
      /// Get the current Firebase user
      User? user = FirebaseAuth.instance.currentUser;

      /// Check if user is authenticated
      if (user != null) {
        /// Get the Firebase user token
        String? token = await user.getIdToken();

        /// Check if token is available
        if (token != null && token.isNotEmpty) {
          /// Include the token in the headers
          final response = await client.get(
            Uri.parse(Consts.dbApiGetFindovioAdvertisement),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
          );

          if (response.statusCode == 200) {
            final responseBody = utf8.decode(response.bodyBytes);
            return parseFindovioAdvertisement(responseBody);
          } else {
            /// Handle HTTP error
            throw Exception('Unable to fetch data: ${response.statusCode}');
          }
        } else {
          /// Token is not available
          throw Exception('Firebase user token not available');
        }
      } else {
        /// User is not authenticated
        throw Exception('User not authenticated');
      }
    } else {
      /// No internet connection
      throw Exception('No internet connection');
    }
  } catch (e) {
    /// Handle any errors
    return FindovioAdvertisement(
        id: 0, forceVisibility: false, url: '', title: '', content: '');

    /// Return an empty object in case of error
  }
}

///
/// token [no]
FindovioAdvertisement parseFindovioAdvertisement(String responseBody) {
  final parsed = jsonDecode(responseBody) as Map<String, dynamic>;
  return FindovioAdvertisement.fromJson(parsed);
}

/// token [+]
Future<List<Advertisement>> fetchAllAdvertisements(http.Client client) async {
  try {
    /// Get the current Firebase user
    User? user = FirebaseAuth.instance.currentUser;

    /// Check if user is authenticated
    if (user != null) {
      /// Get the Firebase user token
      String? token = await user.getIdToken();

      /// Check if token is available
      if (token != null && token.isNotEmpty) {
        /// Include the token in the headers
        final response = await client.get(
          Uri.parse(Consts.dbApiGetAllAdvertisements),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          return compute(parseAdvertisements, utf8.decode(response.bodyBytes));
        } else {
          /// Handle HTTP error
          throw Exception(
              'Unable to fetch advertisements: ${response.statusCode}');
        }
      } else {
        /// Token is not available
        throw Exception('Firebase user token not available');
      }
    } else {
      /// User is not authenticated
      throw Exception('User not authenticated');
    }
  } catch (e) {
    /// Handle any errors
    return [];

    /// Return an empty list in case of error
  }
}

///----------------------------------------------------------------------------

/// [NO NEED]token secured
/// API's for salons
///
///
/// token [+]
Future<List<SalonModel>> fetchSalons(http.Client client) async {
  try {
    /// Check if user is authenticated and get Firebase token
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();

    bool isConnected = await InternetConnection().hasInternetAccess;

    if (isConnected) {
      final response = await client.get(
        Uri.parse(Consts.dbApiGetAll),
        headers: <String, String>{
          'Authorization': 'Bearer $token',

          /// Include Firebase token in headers
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        return compute(parseSalons, responseBody);
      } else {
        /// Handle non-200 status code
        throw Exception('Failed to load salons: ${response.statusCode}');
      }
    } else {
      /// Handle no internet connection
      throw Exception('Brak połączenia z internetem');
    }
  } catch (e) {
    /// Handle any errors
    return [];

    /// Return an empty list in case of error
  }
}

/// token [no]
Future<List<SalonModel>> fetchSearchSalons(http.Client client,
    {String? keywords,
    String? address,
    String? radius,
    String? category}) async {
  String query = '';

  if (keywords != null) {
    keywords = keywords.replaceAll(' ', '%20');
    query += 'keywords=$keywords';
  }

  if (address != null) {
    address = address.replaceAll(' ', '%20');
    if (query.isNotEmpty) {
      query += '&';
    }
    query += 'address=$address';
  }
  if (category != null) {
    if (query.isNotEmpty) {
      query += '&';
    }
    query += 'category=$category';
  }

  final response = await client.get(Uri.parse('${Consts.dbApiSearch}$query'));
  print(Uri.parse('${Consts.dbApiSearch}$query'));
  final responseBody = utf8.decode(response.bodyBytes);
  return compute(parseSalons, responseBody);
}

/// token [+]
Future<List<SalonWorkingHours>> fetchSalonWorkingHours(
    http.Client client, int salonId) async {
  try {
    /// Get the current Firebase user
    User? user = FirebaseAuth.instance.currentUser;

    /// Check if user is authenticated
    if (user != null) {
      /// Get the Firebase user token
      String? token = await user.getIdToken();

      /// Check if token is available
      if (token != null && token.isNotEmpty) {
        /// Include the token in the headers
        final response = await client.get(
          Uri.parse(
              'https://api.findovio.nl/api/fixed-operating-hours/?format=json&salon=$salonId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          return compute(parseWorkingHours, utf8.decode(response.bodyBytes));
        } else {
          /// Handle HTTP error
          throw Exception(
              'Unable to fetch salon working hours: ${response.statusCode}');
        }
      } else {
        /// Token is not available
        throw Exception('Firebase user token not available');
      }
    } else {
      /// User is not authenticated
      throw Exception('User not authenticated');
    }
  } catch (e) {
    /// Handle any errors
    return [];

    /// Return an empty list in case of error
  }
}

/// token [+]
Future<SalonModel> fetchOneSalons(http.Client client, int salonID) async {
  try {
    /// Check if user is authenticated and get Firebase token
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();

    final response = await client.get(
      Uri.parse('${Consts.dbApiGetOne}$salonID/?format=json'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',

        /// Include Firebase token in headers
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      return compute(parseSalon, responseBody);
    } else {
      /// Handle non-200 status code
      throw Exception('Failed to fetch salon: ${response.statusCode}');
    }
  } catch (e) {
    /// Handle any errors
    return Future.error(e);
  }
}

/// token [no]
SalonModel parseSalon(String responseBody) {
  final parsed = jsonDecode(responseBody) as Map<String, dynamic>;
  return SalonModel.fromJson(parsed);
}

/// token [no]
List<SalonModel> parseSalons(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  List<SalonModel> toRemove = [];
  List<SalonModel> result =
      parsed.map<SalonModel>((json) => SalonModel.fromJson(json)).toList();
  for (var element in result) {
    if (element.errorCode == 1) {
      toRemove.add(element);
    }
  }
  result.removeWhere((element) => toRemove.contains(element));
  return result;
}

/// token [+]
Future<List<SalonSchedule>> fetchSalonSchedules(
    http.Client client, int salonId) async {
  try {
    /// Get the current Firebase user
    User? user = FirebaseAuth.instance.currentUser;

    /// Check if user is authenticated
    if (user != null) {
      /// Get the Firebase user token
      String? token = await user.getIdToken();

      /// Check if token is available
      if (token != null && token.isNotEmpty) {
        /// Include the token in the headers
        final response = await client.get(
          Uri.parse(
              'https://api.findovio.nl/api/generatedtimeslots/?format=json&salon=$salonId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          String responseBody = utf8.decode(response.bodyBytes);
          return compute(parseSchedules, responseBody);
        } else {
          /// Handle HTTP error
          throw Exception(
              'Failed to load schedules from API: ${response.statusCode}');
        }
      } else {
        /// Token is not available
        throw Exception('Firebase user token not available');
      }
    } else {
      /// User is not authenticated
      throw Exception('User not authenticated');
    }
  } catch (e) {
    /// Handle any errors
    return [];

    /// Return an empty list in case of error
  }
}

/// token [no]
List<SalonSchedule> parseSchedules(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<SalonSchedule>((json) => SalonSchedule.fromJson(json))
      .toList();
}

/// token [no]
class FetchSalonServiceException implements Exception {
  final String message;
  FetchSalonServiceException(this.message);
}

/// token [+]
Future<Services> fetchSalonService(http.Client client, int service) async {
  try {
    /// Get the current Firebase user
    User? user = FirebaseAuth.instance.currentUser;

    /// Check if user is authenticated
    if (user != null) {
      /// Get the Firebase user token
      String? token = await user.getIdToken();

      /// Check if token is available
      if (token != null && token.isNotEmpty) {
        /// Include the token in the headers
        final response = await client.get(
          Uri.parse('${Consts.dbApiGetSalonService}$service/?format=json'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          return compute(parseSalonService, utf8.decode(response.bodyBytes));
        } else {
          throw FetchSalonServiceException('Failed to load appointments');
        }
      } else {
        /// Token is not available
        throw FetchSalonServiceException('Firebase user token not available');
      }
    } else {
      /// User is not authenticated
      throw FetchSalonServiceException('User not authenticated');
    }
  } catch (e) {
    /// Handle any errors
    throw FetchSalonServiceException('Error fetching appointments: $e');
  }
}

/// token [no]
Services parseSalonService(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Services>((json) => Services.fromJson(json)).toList();
}

/// token [+]
Future<List<Review>> fetchReviews(int salonId) async {
  try {
    /// Pobierz obecnie zalogowanego użytkownika Firebase
    User? user = FirebaseAuth.instance.currentUser;

    /// Upewnij się, że użytkownik jest zalogowany
    if (user != null) {
      /// Pobierz token uwierzytelniający dla użytkownika
      String? token = await user.getIdToken();

      /// Sprawdź czy token został pomyślnie pobrany
      if (token != null && token.isNotEmpty) {
        /// Utwórz nagłówek z tokenem
        Map<String, String> headers = {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        };

        final response = await http.get(
          Uri.parse('${Consts.dbApiGetReviews}$salonId/reviews/?format=json'),
          headers: headers,

          /// Dodaj nagłówek z tokenem
        );

        if (response.statusCode == 200) {
          Iterable l = json.decode(utf8.decode(response.bodyBytes));
          return List<Review>.from(l.map((model) => Review.fromJson(model)));
        } else {
          throw Exception('Failed to load reviews');
        }
      } else {
        throw Exception('Token error');

        /// Błąd pobierania tokenu
      }
    } else {
      throw Exception('User not logged in');

      /// Użytkownik nie jest zalogowany
    }
  } catch (e) {
    throw Exception('Error fetching reviews: $e');
  }
}

/// token [no]
Future<String> getPhoto(String? imageUrl) async {
  if (imageUrl == null) return '';
  final image = CachedNetworkImageProvider(imageUrl);
  return image.url;
}

/// token [+]
Future<String> sendPostRequest(Map<String, dynamic> dataToSend) async {
  try {
    /// Get the current Firebase user
    User? user = FirebaseAuth.instance.currentUser;

    /// Check if user is authenticated
    if (user != null) {
      /// Get the Firebase user token
      String? token = await user.getIdToken();

      /// Check if token is available
      if (token != null && token.isNotEmpty) {
        /// Include the token in the headers
        final url = Uri.parse(Consts.dbApiPostBooking);
        final headers = <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        };

        final response = await http.post(
          url,
          headers: headers,
          body: jsonEncode(dataToSend),

          /// Use the provided data as the body
        );

        if (response.statusCode == 201) {
          return 'success';
        } else if (response.statusCode == 400) {
          return 'bad_request';
        } else {
          return 'unexpected_error';
        }
      } else {
        /// Token is not available
        return 'token_not_available';
      }
    } else {
      /// User is not authenticated
      return 'user_not_authenticated';
    }
  } catch (e) {
    /// Handle any errors
    return 'error';
  }
}

/// token [+]
Future<String> sendPostReviewRequest(Map<String, dynamic> dataToSend) async {
  try {
    /// Get the current Firebase user
    User? user = FirebaseAuth.instance.currentUser;

    /// Check if user is authenticated
    if (user != null) {
      /// Get the Firebase user token
      String? token = await user.getIdToken();

      /// Check if token is available
      if (token != null && token.isNotEmpty) {
        /// Include the token in the headers
        final url = Uri.parse(Consts.dbApiPostReview);
        final headers = <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        };

        final response = await http.post(
          url,
          headers: headers,
          body: jsonEncode(dataToSend),

          /// Use the provided data as the body
        );

        if (response.statusCode == 201) {
          return 'success';
        } else if (response.body.contains('notunique')) {
          return 'not_unique';
        } else if (response.statusCode == 400) {
          return 'bad_request';
        } else {
          return 'unexpected_error';
        }
      } else {
        /// Token is not available
        return 'token_not_available';
      }
    } else {
      /// User is not authenticated
      return 'user_not_authenticated';
    }
  } catch (e) {
    /// Handle any errors
    return 'error';
  }
}

/// token [no]
List<SalonWorkingHours> parseWorkingHours(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<SalonWorkingHours>((json) => SalonWorkingHours.fromJson(json))
      .toList();
}

///------------------------------------------------------------------------------

/// [NO NEED] token secured
/// API's for search and keywords
///
///
/// token [no]
Future<List<DiscoverPageKeywordsList>> fetchKeywordsList(
    http.Client client) async {
  try {
    const url = Consts.dbApiGetKeywordsList;
    final response = await client.get(Uri.parse(url));
    final responseBody = utf8.decode(response.bodyBytes);
    return compute(parseKeywordsList, responseBody);
  } catch (e) {
    return [];
  }
}

/// token [no]
List<DiscoverPageKeywordsList> parseKeywordsList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<DiscoverPageKeywordsList>(
          (json) => DiscoverPageKeywordsList.fromJson(json))
      .toList();
}

///------------------------------------------------------------------------------

/// [NO NEED] token secured
/// API's for User register
///
///
/// token [+]
Future<int> changeFirebasePyUser(
    http.Client client, String userNameToChange, String userUid) async {
  try {
    /// Get the current Firebase user
    User? user = FirebaseAuth.instance.currentUser;

    /// Check if user is authenticated
    if (user != null) {
      /// Get the Firebase user token
      String? token = await user.getIdToken();

      /// Check if token is available
      if (token != null && token.isNotEmpty) {
        /// Prepare the data to be sent in the patch request
        Map<String, dynamic> data = {"firebase_name": "$userNameToChange"};

        /// Make the patch request with the token included in the headers
        final response = await client.patch(
          Uri.parse(
              '${Consts.dbApiChangeFirebaseUser}$userUid/update_firebase_user/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',

            /// Include the token in the headers
          },
          body: jsonEncode(data),
        );

        return response.statusCode;
      } else {
        /// Token is not available
        throw Exception('Firebase user token not available');
      }
    } else {
      /// User is not authenticated
      throw Exception('User not authenticated');
    }
  } catch (e) {
    /// Handle any errors
    return 0;
  }
}

/// token [+]
Future<FirebasePyGetModel> fetchFirebasePyUser(
    http.Client client, String userUid) async {
  try {
    /// Pobierz obecnie zalogowanego użytkownika Firebase
    User? user = FirebaseAuth.instance.currentUser;

    /// Sprawdź, czy użytkownik jest zalogowany
    if (user != null) {
      /// Pobierz token uwierzytelniający dla użytkownika
      String? token = await user.getIdToken();

      /// Sprawdź, czy token jest dostępny
      if (token != null && token.isNotEmpty) {
        /// Utwórz nagłówek z tokenem
        Map<String, String> headers = {
          'Authorization': 'Bearer $token',
        };

        /// Utwórz URL do żądania GET
        Uri url = Uri.parse(
            '${Consts.dbApiGetFirebaseUserByUid}$userUid/?format=json');

        /// Wykonaj żądanie GET z nagłówkiem uwierzytelniającym
        final response = await client.get(
          url,
          headers: headers,
        );

        /// Sprawdź, czy żądanie zakończyło się sukcesem
        if (response.statusCode == 200) {
          /// Parsuj odpowiedź i zwróć użytkownika
          final responseBody = utf8.decode(response.bodyBytes);
          final user = parseFirebasePyUser(responseBody);
          print(
              'fetchFirebasePyUser zakończone poprawnie: ${user.firebaseName}');
          return user;
        } else {
          /// Obsłuż błędy żądania
          print('fetchFirebasePyUser zakończone niepoprawnie: $user');
          return Future.value();

          /// Zwróć pustego użytkownika
        }
      } else {
        print('fetchFirebasePyUser zakończone niepoprawnie: $user');
        return Future.value();

        /// Zwróć pustego użytkownika
      }
    } else {
      print('fetchFirebasePyUser zakończone niepoprawnie: $user');
      return Future.value();

      /// Zwróć pustego użytkownika
    }
  } catch (e) {
    print('fetchFirebasePyUser zakończone niepoprawnie: $e');
    return Future.value();

    /// Zwróć pustego użytkownika
  }
}

/// token [no]
FirebasePyGetModel parseFirebasePyUser(String responseBody) {
  final parsed = jsonDecode(responseBody) as Map<String, dynamic>;
  return FirebasePyGetModel.fromJson(parsed);
}

/// token [no]
FirebasePyRegisterModel parseRegister(String responseBody) {
  final parsed = jsonDecode(responseBody) as Map<String, dynamic>;
  return FirebasePyRegisterModel.fromJson(parsed);
}

/// token [+]
Future<String> sendPostRegisterRequest(
    FirebasePyRegisterModel userModel) async {
  try {
    // Get the current Firebase user
    User? user = FirebaseAuth.instance.currentUser;

    // Check if user is authenticated
    if (user != null) {
      // Get the Firebase user token
      String? token = await user.getIdToken();

      // Check if token is available
      if (token != null && token.isNotEmpty) {
        // Include the token in the headers
        final url = Uri.parse(Consts.dbApiRegisterFirebaseUser);
        final headers = <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        };
        final dataToSend = userModel.toJson();

        final response = await http.post(
          url,
          headers: headers,
          body: jsonEncode(dataToSend),
        );

        if (response.statusCode == 201) {
          return 'success';
        } else if (response.statusCode == 400) {
          return 'bad_request';
        } else {
          return 'unexpected_error';
        }
      } else {
        // Token is not available
        return 'token_not_available';
      }
    } else {
      // User is not authenticated
      return 'user_not_authenticated';
    }
  } catch (e) {
    // Handle any errors
    return 'error';
  }
}

/// token [+]
Future<String> sendStatusUpdate(
    int appointmentID, String appointmentStatus) async {
  try {
    // Get the current Firebase user
    User? user = FirebaseAuth.instance.currentUser;

    // Check if user is authenticated
    if (user != null) {
      // Get the Firebase user token
      String? token = await user.getIdToken();

      // Check if token is available
      if (token != null && token.isNotEmpty) {
        // Include the token in the headers
        final response = await http.put(
          Uri.parse(
              Consts.dbApiSendStatusChange(appointmentID, appointmentStatus)),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          return response.body.toString();
        } else {
          return response.statusCode.toString();
        }
      } else {
        // Token is not available
        return 'token_not_available';
      }
    } else {
      // User is not authenticated
      return 'user_not_authenticated';
    }
  } catch (e) {
    // Handle any exceptions
    return 'error';
  }
}

/// token [no]
List<Advertisement> parseAdvertisements(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<Advertisement>((json) => Advertisement.fromJson(json))
      .toList();
}

///------------------------------------------------------------------------------

/// [NO NEED] token secured
/// API's for User register
///
///
/// token [+]
Future<List<UserAppointment>> fetchAppointments(
    http.Client client, String userId) async {
  try {
    // Get the current Firebase user
    User? user = FirebaseAuth.instance.currentUser;

    // Check if user is authenticated
    if (user != null) {
      // Get the Firebase user token
      String? token = await user.getIdToken();

      // Check if token is available
      if (token != null && token.isNotEmpty) {
        // Include the token in the headers
        final response = await client.get(
          Uri.parse('${Consts.dbApiGetUserBookings}$userId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
        );

        if (response.statusCode == 200) {
          return compute(parseUserAppointment, utf8.decode(response.bodyBytes));
        } else {
          throw Exception('Failed to load appointments');
        }
      } else {
        // Token is not available
        throw Exception('Firebase user token not available');
      }
    } else {
      // User is not authenticated
      throw Exception('User not authenticated');
    }
  } catch (e) {
    // Handle any exceptions
    return []; // Return an empty list in case of error
  }
}

/// token [no]
List<UserAppointment> parseUserAppointment(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<UserAppointment>((json) => UserAppointment.fromJson(json))
      .toList();
}

/// token [+]
///------------------------------------------------------------------------------

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<SearchResults> searchSalonsAndServices(String query) async {
  try {
    final response = await http.get(
      Uri.parse(
          'http://185.180.204.182:8000/api/search-keywords/?q=$query'), // Zmień na właściwy endpoint
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final utf8Response = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResponse = jsonDecode(utf8Response);
      print(jsonResponse);
      return SearchResults.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load search results');
    }
  } catch (e) {
    throw Exception('Failed to connect to the server');
  }
}
