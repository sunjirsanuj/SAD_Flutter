import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  const CustomTextfield({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    required this.isPassword,
    this.controller,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      //padding: const EdgeInsets.all(10),
      height: 70,
      child: TextField(
        controller: widget.controller,
        cursorColor: Color(0xFF174B3B),
        obscureText: widget.isPassword && !isVisible,

        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: IconTheme(
              data: IconThemeData(color: Colors.grey[800]),
              child: Icon(widget.prefixIcon),
            ),
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey),

          suffixIcon: widget.isPassword
              ? Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                    color: Colors.grey[800],
                    icon: isVisible
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                  ),
                )
              : null,

          filled: true,
          fillColor: Colors.white,

          contentPadding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Color(0xFFE5ECF2), width: 1),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Color(0xFFE5ECF2), width: 1),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Color(0xFF174B3B)),
          ),
        ),
      ),
    );
  }
}
