import 'package:flutter/material.dart';

// Create a class extending ChangeNotifier
class OptionalCategoryProvider extends ChangeNotifier {
  String _optionalCategory = ''; // Field to be updated

  // Getter for the field value
  String get optionalCategory => _optionalCategory;

  // Method to update the field value
  void updateField(String newValue) {
    _optionalCategory = newValue;
    notifyListeners(); // Notify listeners about the change
  }

  void setDefault() {
    _optionalCategory = ''; // Notify listeners about the change
  }
}
