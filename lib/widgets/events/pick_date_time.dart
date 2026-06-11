import 'package:flutter/material.dart';

import '../../data/mock_repository.dart';
import '../../theme/app_theme.dart';

/// Opens a themed date picker then a time picker; returns combined [DateTime].
Future<DateTime?> pickEventDateTime(
  BuildContext context, {
  DateTime? initial,
  String dateHelpText = 'Select event date',
}) async {
  final today = MockRepository.instance.today;
  final seed = initial ?? today.add(const Duration(days: 14));

  final pickedDate = await showDatePicker(
    context: context,
    initialDate: seed,
    firstDate: today,
    lastDate: today.add(const Duration(days: 365)),
    helpText: dateHelpText,
    builder: (context, child) => Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.dark(
          primary: AppColors.gold,
          onPrimary: Colors.black,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
        ),
      ),
      child: child!,
    ),
  );
  if (pickedDate == null || !context.mounted) return null;

  final pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initial ?? seed),
    builder: (context, child) => Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.dark(
          primary: AppColors.gold,
          onPrimary: Colors.black,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
        ),
      ),
      child: child!,
    ),
  );
  if (pickedTime == null) return null;

  return DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
    pickedTime.hour,
    pickedTime.minute,
  );
}
