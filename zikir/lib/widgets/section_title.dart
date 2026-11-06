import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionTitle(this.title, {super.key, this.action, this.onAction});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1D2924),
            )),
          ),
          if (action != null)
            TextButton(onPressed: onAction, child: Text(action!)),
        ],
      );
}
