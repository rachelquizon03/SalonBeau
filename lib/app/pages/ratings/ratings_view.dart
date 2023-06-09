import 'package:flutter/material.dart';
import 'package:salon_app/data/ratings_repository.dart';
import 'package:salon_app/data/salon_repository.dart';
import 'package:salon_app/domain/entities/rating.dart';

class RatingsView extends StatefulWidget {
  const RatingsView({super.key});

  @override
  State<RatingsView> createState() => _RatingsViewState();
}

class _RatingsViewState extends State<RatingsView> {
  List<Rating> _ratings = [];

  void getRatings() async {
    final ratings =
        await RatingsRepository().getRatingsByUid(SalonRepository.salon!.id);
    setState(() {
      _ratings = ratings;
    });
  }

  @override
  void initState() {
    getRatings();
    super.initState();
  }

  void handleBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFFFD9ED),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 25.0,
                horizontal: 15.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: handleBack,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFFC93480),
                          size: 28.0,
                        ),
                      ),
                      const Text(
                        'Ratings & Feedbacks',
                        style: TextStyle(
                          color: Color(0xFFC93480),
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  ..._ratings
                      .map(
                        (rating) => RatingColumn(
                          review: rating.review,
                          star: rating.star,
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RatingColumn extends StatelessWidget {
  const RatingColumn({
    super.key,
    required this.review,
    required this.star,
  });
  final String review;
  final String star;
  @override
  Widget build(BuildContext context) {
    final starNo = int.parse(star);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 15.0),
        Row(
          children: [
            Icon(
              Icons.star,
              size: 14.0,
              color: starNo >= 1 ? const Color(0xFFC93480) : Colors.black54,
            ),
            Icon(
              Icons.star,
              size: 14.0,
              color: starNo >= 2 ? const Color(0xFFC93480) : Colors.black54,
            ),
            Icon(
              Icons.star,
              size: 14.0,
              color: starNo >= 3 ? const Color(0xFFC93480) : Colors.black54,
            ),
            Icon(
              Icons.star,
              size: 14.0,
              color: starNo >= 4 ? const Color(0xFFC93480) : Colors.black54,
            ),
            Icon(
              Icons.star,
              size: 14.0,
              color: starNo >= 5 ? const Color(0xFFC93480) : Colors.black54,
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Text(review, textAlign: TextAlign.left),
        const SizedBox(height: 15.0),
        const Divider(),
      ],
    );
  }
}
