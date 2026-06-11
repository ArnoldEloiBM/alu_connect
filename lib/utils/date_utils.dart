/// Small date helpers for feed copy. Kept dependency-free so we don't need to
/// pull in `intl` just for a few formats.
library;

import 'package:flutter/material.dart';

const _months = [
  'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
  'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
];

const _monthsLong = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// Two-letter day for a badge, e.g. "14".
String dayNumber(DateTime d) => d.day.toString().padLeft(2, '0');

/// Short month for a badge, e.g. "OCT".
String monthShort(DateTime d) => _months[d.month - 1];

/// e.g. "Oct 24, 2024".
String prettyDate(DateTime d) => '${_monthsLong[d.month - 1]} ${d.day}, ${d.year}';

/// Human relative copy for a deadline, e.g. "Ends in 2 days".
String endsIn(DateTime deadline, DateTime now) {
  final diff = DateTime(deadline.year, deadline.month, deadline.day)
      .difference(DateTime(now.year, now.month, now.day))
      .inDays;
  if (diff < 0) return 'Closed';
  if (diff == 0) return 'Ends today';
  if (diff == 1) return 'Ends tomorrow';
  return 'Ends in $diff days';
}

/// Returns urgency color and text for deadline indicator.
/// Red (<3 days), Yellow (<7 days), White (normal).
class DeadlineIndicator {
  final Color color;
  final String text;

  const DeadlineIndicator({required this.color, required this.text});

  factory DeadlineIndicator.from(DateTime deadline, DateTime now) {
    final diff = DateTime(deadline.year, deadline.month, deadline.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;

    if (diff < 0) {
      return DeadlineIndicator(
        color: const Color(0xFFE5484D),
        text: 'Closed',
      );
    } else if (diff <= 3) {
      return DeadlineIndicator(
        color: const Color(0xFFE5484D),
        text: '$diff days left',
      );
    } else if (diff <= 7) {
      return DeadlineIndicator(
        color: const Color(0xFFF5B301),
        text: '$diff days left',
      );
    } else {
      return DeadlineIndicator(
        color: const Color(0xFFF5F7FA),
        text: prettyDate(deadline),
      );
    }
  }
}
