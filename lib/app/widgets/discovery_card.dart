import 'package:flutter/material.dart';

class DiscoveryCard extends StatelessWidget {
  const DiscoveryCard({
    super.key,
    this.urlLogo,
    this.onTap,
  });
  final String? urlLogo;
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
          width: 156.0,
          height: 128.0,
          child: Image.network(urlLogo!),
        ),
      ),
    );
  }
}
