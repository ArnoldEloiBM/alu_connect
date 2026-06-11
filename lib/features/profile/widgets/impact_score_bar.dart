import 'package:flutter/material.dart';
import '../models/user.dart';

// Shows the impact score, a progress bar, and rank label.
// Used inside ProfileScreen.

class ImpactScoreBar extends StatelessWidget {
  final User user;

  const ImpactScoreBar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Calculate progress as a value between 0.0 and 1.0
    double progress = user.impactScore / user.maxImpactScore;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2B4B), // dark navy card
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: label on left, score on right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'IMPACT SCORE',
                style: TextStyle(
                  color: Color(0xFFF5B800), // gold
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                '${user.impactScore} / ${user.maxImpactScore}',
                style: const TextStyle(
                  color: Color(0xFFF5B800),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // The gold progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFF2E3D5C),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF5B800)),
            ),
          ),

          const SizedBox(height: 8),

          // Rank and next level
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                user.rankLabel,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                'Next Level: ${user.nextLevel}',
                style: const TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}