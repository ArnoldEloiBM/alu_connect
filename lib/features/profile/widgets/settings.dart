import 'package:flutter/material.dart';

// A single toggle row used in SettingsScreen.
// Has a label on the left and a Switch on the right.

class SettingsToggle extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggle({
    super.key,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? Colors.white : const Color(0xFF0D1B2A);
    final subtitleColor =
        isDark ? Colors.white54 : Colors.black.withValues(alpha: 0.55);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: labelColor, fontSize: 14),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: TextStyle(color: subtitleColor, fontSize: 12),
                ),
              ],
            ],
          ),
        ),

        // Right side: the toggle switch
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: const Color(0xFFF5B800),
          activeTrackColor: const Color(0xFF3A4D6B),
          inactiveThumbColor: Colors.white38,
          inactiveTrackColor: const Color(0xFF2A3A55),
        ),
      ],
    );
  }
}
