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
    return Row(
      children: [
        // Left side: label and optional subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
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
