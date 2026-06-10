import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

/// Horizontal row of filter chips for the home feed.
///
/// `selected == null` represents the "All" option. The widget is stateless;
/// the parent owns the selected value and rebuilds on change.
class FilterChips extends StatelessWidget {
  final OpportunityType? selected;
  final ValueChanged<OpportunityType?> onSelected;

  /// Which types to expose as chips (besides "All").
  final List<OpportunityType> types;

  const FilterChips({
    super.key,
    required this.selected,
    required this.onSelected,
    this.types = const [
      OpportunityType.hackathon,
      OpportunityType.internship,
    ],
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _chip(label: 'All', isSelected: selected == null, onTap: () => onSelected(null)),
          for (final t in types)
            _chip(
              label: t.label + (t == OpportunityType.hackathon ? 's' : 's'),
              isSelected: selected == t,
              onTap: () => onSelected(t),
            ),
        ],
      ),
    );
  }

  Widget _chip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.gold : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.gold : AppColors.border,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
