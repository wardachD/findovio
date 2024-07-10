import 'package:findovio/models/salon_reviews_model.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:flutter/material.dart';

import 'reviews_widgets/reviews_list_widget.dart';

class SalonReviews extends StatefulWidget {
  final int salonId;

  const SalonReviews({super.key, required this.salonId});

  @override
  State<SalonReviews> createState() => _SalonReviewsState();
}

class _SalonReviewsState extends State<SalonReviews> {
  late Future<List<Review>> futureReviews;

  @override
  void initState() {
    super.initState();
    futureReviews = fetchReviews(widget.salonId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Review>>(
      future: futureReviews,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Review> reviews = snapshot.data!;
          return Scaffold(
            body: ReviewsWidget(reviews: reviews),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
