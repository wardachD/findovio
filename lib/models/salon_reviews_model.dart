class Review {
  final int id;
  final int salon;
  final String userId;
  final int rating;
  final String comment;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.salon,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int,
      salon: json['salon'] as int,
      userId: json['user_id'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      imageUrl: json['image_url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'salon': salon,
      'user_id': userId,
      'rating': rating,
      'comment': comment,
      'image_url': imageUrl,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
  }
}
