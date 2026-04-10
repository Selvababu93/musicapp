import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  const AuthGradientButton({
    super.key,
    required this.buttonText,
    required this.onTap,
  });
  final String buttonText;
  final VoidCallback onTap;

  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Pallete.gradient1, Pallete.gradient2],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(395, 55),
          backgroundColor: Pallete.transparentColor,
          shadowColor: Pallete.transparentColor,
        ),
        onPressed: onTap,
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
