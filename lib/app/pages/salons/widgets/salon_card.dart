import 'package:flutter/material.dart';

class SalonCard extends StatelessWidget {
  const SalonCard({
    super.key,
    required this.title,
    required this.urlLogo,
    required this.totalRatings,
    this.onTap,
  });

  final String title, urlLogo;
  final double totalRatings;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Container(
          padding: const EdgeInsets.only(
            left: 25.0,
            top: 15.0,
            right: 25.0,
            bottom: 15.0,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFFC93480),
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: Image.network(urlLogo),
                    ),
                    const SizedBox(width: 15.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.white),
                              Text(
                                'Rating: $totalRatings',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: const [
                  Text(
                    'Visit us',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 24.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
