import 'package:flutter/material.dart';

class CustomIconTextButton extends StatelessWidget {
  final String buttonContent;
  final Color borderColor;
  final Color backgroundColor;
  final Image buttonIcon;
  const CustomIconTextButton({
    super.key,
    required this.buttonContent,
    required this.borderColor,
    required this.backgroundColor,
    required this.buttonIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 25),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: BoxBorder.all(color: Color(0xFFE5ECF2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/google.png", height: 25),
          const SizedBox(width: 15),
          Text(
            "Continue with Goolge",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
