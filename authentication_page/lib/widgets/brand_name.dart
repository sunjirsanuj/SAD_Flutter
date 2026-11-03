import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
              color: Color(0xFF174B3B),
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
