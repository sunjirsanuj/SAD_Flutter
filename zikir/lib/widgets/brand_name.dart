import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zikir_tracker/theme/app_theme.dart';

class BrandName extends StatelessWidget {
  final double fontSize;
  const BrandName({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Zikra",
            style: GoogleFonts.poppins(
              color: AppTheme.forest,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Text(
          //   "Siswa",
          //   style: GoogleFonts.poppins(
          //     fontSize: fontSize,
          //     fontWeight: FontWeight.bold,
          //     color: AppTheme.forest,
          //   ),
          // ),
        ],
      ),
    );
  }
}
