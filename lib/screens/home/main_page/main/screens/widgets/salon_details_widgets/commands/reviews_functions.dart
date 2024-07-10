import 'package:findovio/models/salon_reviews_model.dart';
import 'package:flutter/material.dart';

double getAverageReviews(List<Review> reviews) {
  if (reviews.isNotEmpty) {
    double sum = 0;
    for (var review in reviews) {
      sum += review.rating;
    }
    return sum / reviews.length;
  } else {
    return 0.0;
  }
}

List<int> getReviewCounts(List<Review> reviews) {
  List<int> reviewCounts = List.filled(5, 0);

  for (Review review in reviews) {
    int rating = review.rating.toInt();
    if (rating >= 1 && rating <= 5) {
      reviewCounts[rating - 1]++;
    }
  }

  return reviewCounts;
}

Widget getImageIfExists(String url) {
  if (url != '') {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text('Zdjęcia: '),
        const SizedBox(height: 8),
        ClipRRect(
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.hardEdge,
            child: Image.network(url, height: 110)),
      ],
    ); // use network image
  } else {
    return const SizedBox.shrink(); // returns an empty box
  }
}
