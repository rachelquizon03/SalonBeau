import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {
  const AppElevatedButton({
    super.key,
    required this.child,
    this.onPressed,
  });

  final void Function()? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFC93480),
        padding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 25.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
