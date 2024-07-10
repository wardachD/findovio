import 'package:findovio/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:findovio/models/salon_reviews_model.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/salon_details_widgets/reviews_widgets/reviews_card.dart';
import '../commands/reviews_functions.dart';

class ReviewsWidget extends StatelessWidget {
  final List<Review> reviews;

  const ReviewsWidget({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/images/pusto_tutaj.png'),
        ]),
      );
    }

    List<int> reviewCounts = getReviewCounts(reviews);
    double averageReview = getAverageReviews(reviews);
    int totalReviews = reviewCounts.reduce((a, b) => a + b);

    return ListView(
      children: [
        const SizedBox(height: 20),
        Container(
          width: MediaQuery.sizeOf(context).width * 0.5,
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    averageReview.toStringAsFixed(1),
                    style: const TextStyle(
                      color: AppColors.primaryLightColorText,
                      fontWeight: FontWeight.w500,
                      fontSize: 52,
                    ),
                  ),
                  const SizedBox(width: 10),
                  RatingBar.builder(
                    ignoreGestures: true,
                    initialRating: getAverageReviews(reviews),
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 18.0,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star_outlined,
                      color: Colors.orangeAccent,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                  Text(
                    '${reviews.length}',
                    style:
                        const TextStyle(color: AppColors.primaryLightColorText),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildStarProgress(5, reviewCounts, totalReviews, context),
                    _buildStarProgress(4, reviewCounts, totalReviews, context),
                    _buildStarProgress(3, reviewCounts, totalReviews, context),
                    _buildStarProgress(2, reviewCounts, totalReviews, context),
                    _buildStarProgress(1, reviewCounts, totalReviews, context),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Divider(),
        ...reviews.map((review) => reviewsCard(context, review)).toList(),
      ],
    );
  }

  Widget _buildStarProgress(int starCount, List<int> reviewCounts,
      int totalReviews, BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.55,
      child: Row(
        children: [
          Text(
            '$starCount',
            style: const TextStyle(color: AppColors.primaryLightColorText),
          ),
          SizedBox(width: (MediaQuery.sizeOf(context).width * 0.05)),
          Flexible(
            flex: 1,
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(12),
              minHeight: 9,
              value: reviewCounts[starCount - 1] / totalReviews.toDouble(),
              color: Colors.orangeAccent,
              backgroundColor: AppColors.lightColorTextField,
            ),
          ),
        ],
      ),
    );
  }
}
