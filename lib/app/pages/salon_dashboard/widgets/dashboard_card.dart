import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    this.onTap,
    required this.title,
  });

  final String title;
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
            // color: Color(0xFFC93480),
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFC93480),
                      fontSize: 18.0,
                    ),
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
