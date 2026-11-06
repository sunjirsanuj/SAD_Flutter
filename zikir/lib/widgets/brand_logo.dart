import 'package:flutter/material.dart';
import 'package:zikir_tracker/theme/app_theme.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
      decoration: BoxDecoration(
        color: AppTheme.forest,
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.forest, AppTheme.green],
        ),
      ),

      child: Icon(Icons.spa_outlined, size: 40, color: Colors.white),
    );
  }
}
