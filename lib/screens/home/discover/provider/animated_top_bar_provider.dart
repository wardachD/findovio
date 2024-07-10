import 'package:flutter/material.dart';

// Create a class extending ChangeNotifier
class AnimatedTopBarProvider extends ChangeNotifier {
  bool _isTopBarVisible = true; // Field to be updated

  // Getter for the field value
  bool get isTopBarVisible => _isTopBarVisible;

  // Method to update the field value
  void updateField(bool newValue) {
    _isTopBarVisible = newValue;
    notifyListeners(); // Notify listeners about the change
  }

  void setDefault() {
    _isTopBarVisible = true; // Notify listeners about the change
  }
}
