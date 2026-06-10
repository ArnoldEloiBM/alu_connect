import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable search input used on the Discover screen. Stateless: parent owns
/// the controller and reacts to `onChanged`.
class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final String hint;

  const SearchField({
    super.key,
    required this.controller,
    this.onChanged,
    this.onFilterTap,
    this.hint = 'Search events, clubs, or members...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
              cursorColor: AppColors.gold,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          IconButton(
            onPressed: onFilterTap,
            icon: const Icon(Icons.tune, color: AppColors.gold, size: 20),
            tooltip: 'Filters',
          ),
        ],
      ),
    );
  }
}
