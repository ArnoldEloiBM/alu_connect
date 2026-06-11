import 'package:flutter/material.dart';

// A small badge widget: circle icon + label below.
// Used in a horizontal row on the ProfileScreen.

class AchievementBadge extends StatelessWidget {
  final String label;
  final IconData icon;

  const AchievementBadge({
    super.key,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Gold circle with icon inside
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: Color(0xFF1B2B4B),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFFF5B800), size: 26),
        ),

        const SizedBox(height: 6),

        // Badge label
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}