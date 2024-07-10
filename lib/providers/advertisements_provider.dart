import 'package:findovio/models/advertisement_model.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdvertisementProvider extends ChangeNotifier {
  List<Advertisement> _advertisements = [];

  List<Advertisement> get advertisements => _advertisements;

  Future<void> fetchAdvertisements() async {
    try {
      final List<Advertisement> fetchedAdvertisements =
          await fetchAllAdvertisements(http.Client());

      _advertisements = fetchedAdvertisements;
      notifyListeners();
    } catch (e) {
      print('Error fetching advertisements: $e');
    }
  }
}
