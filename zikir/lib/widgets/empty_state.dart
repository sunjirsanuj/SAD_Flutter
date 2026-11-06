import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.spa_outlined,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 24),
        child: Column(
          children: [
            Container(
              width: 76, height: 76,
              decoration: const BoxDecoration(color: Color(0xFFE7F3EE), shape: BoxShape.circle),
              child: Icon(icon, size: 34, color: const Color(0xFF174B3B)),
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 7),
            Text(message, textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, height: 1.45)),
          ],
        ),
      );
}
