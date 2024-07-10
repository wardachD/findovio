class DiscoverPageKeywordsList {
  final String word;
  final int count;

  DiscoverPageKeywordsList({
    required this.word,
    required this.count,
  });

  factory DiscoverPageKeywordsList.fromJson(Map<String, dynamic> json) {
    return DiscoverPageKeywordsList(
      word: json['word'] as String,
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'count': count,
    };
  }
}
