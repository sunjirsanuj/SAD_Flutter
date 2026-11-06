import 'package:flutter/material.dart';
import 'package:zikir_tracker/theme/app_theme.dart';

class Button extends StatelessWidget {
  final String buttonContent;
  final double borderRadius;
  const Button({
    super.key,
    required this.buttonContent,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 25),

      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.green,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        buttonContent,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
