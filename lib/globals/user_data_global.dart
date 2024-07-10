import 'package:flutter/material.dart';

class GlobalScrollController {
  final ScrollController _scrollController = ScrollController();
  bool isVisible = true;

  ScrollController get scrollController => _scrollController;

  void removeListener() {
    _scrollController.dispose();
  }

  setVisibility(bool value) {
    isVisible = value;
  }

  bool getVisibility() {
    return isVisible;
  }
}
