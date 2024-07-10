import 'dart:convert';
import 'package:findovio/models/salon_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteSalonsProvider extends ChangeNotifier {
  List<SalonModel> _salons = [];
  static const String _key = 'favoriteSalons';

  FavoriteSalonsProvider() {
    // Load favorite salons from SharedPreferences when the provider is initialized
    _loadSalons();
  }

  List<SalonModel> get salons => _salons;

  // Method to add a salon
  void addSalon(SalonModel salon) {
    _salons.add(salon);
    _saveSalons();
    notifyListeners();
  }

  // Method to delete a salon by its index
  void deleteSalon(int index) {
    if (index >= 0 && index < _salons.length) {
      _salons.removeAt(index);
      _saveSalons();
      notifyListeners();
    }
  }

  // Method to get all salons
  List<SalonModel> getSalons() {
    return _salons;
  }

  // Load favorite salons from SharedPreferences
  Future<void> _loadSalons() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_key);
    if (jsonString != null) {
      Iterable decoded = jsonDecode(jsonString);
      _salons = decoded.map((salon) => SalonModel.fromJson(salon)).toList();
      notifyListeners();
    }
  }

  // Save favorite salons to SharedPreferences
  Future<void> _saveSalons() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(_salons);
    await prefs.setString(_key, jsonString);
  }

  void clearFavorites() {
    _salons = [];
  }
}
