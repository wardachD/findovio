import 'package:findovio/models/discover_page_filter_model.dart';
import 'package:flutter/material.dart';

class DiscoverPageFilterProvider with ChangeNotifier {
  final DiscoverPageFilterModel _userData = DiscoverPageFilterModel();

  DiscoverPageFilterModel get userData => _userData;

  void setAllToEmpty() {
    _userData.category = '';
    _userData.city = '';
    _userData.gender = '';
    notifyListeners();
  }

  void setAllToEmptyWithoutNotification() {
    _userData.category = '';
    _userData.city = '';
    _userData.gender = '';
  }

  void setForWhom(String value) {
    _userData.gender = value;
    notifyListeners();
  }

  void setCategory(String value) {
    _userData.category = value;
    notifyListeners();
  }

  void setCategoryWithoutNotifying(String value) {
    _userData.category = value;
  }

  void setTempWithoutNotifying(String value) {
    _userData.categoryTemp = value;
  }

  void setCity(String value) {
    _userData.city = value;
    notifyListeners();
  }

  void setCityWithoutNotyfing(String value) {
    _userData.city = value;
  }
}
