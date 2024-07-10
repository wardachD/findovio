class FindovioAdvertisement {
  final int id;
  final bool forceVisibility;
  final String url;
  final String title;
  final String content;

  FindovioAdvertisement({
    required this.id,
    required this.forceVisibility,
    required this.url,
    required this.title,
    required this.content,
  });

  bool isEmpty() {
    return id == 0 && !forceVisibility && url == '';
  }

  factory FindovioAdvertisement.fromJson(Map<String, dynamic> json) {
    return FindovioAdvertisement(
      id: json['id'] as int,
      forceVisibility: json['forceVisibility'] as bool,
      url: json['url'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'forceVisibility': forceVisibility,
      'url': url,
      'title': title,
      'content': content,
    };
  }
}
