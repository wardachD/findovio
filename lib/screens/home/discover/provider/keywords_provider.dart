import 'package:findovio/models/discover_page_keywords_list.dart';
import 'package:flutter/foundation.dart';

class KeywordProvider with ChangeNotifier {
  List<DiscoverPageKeywordsList> _keywords = [];

  List<DiscoverPageKeywordsList> get keywords => _keywords;

  void setKeywords(List<DiscoverPageKeywordsList> newKeywords) {
    _keywords = newKeywords;
    notifyListeners();
  }
}
