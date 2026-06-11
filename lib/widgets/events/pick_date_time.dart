import 'package:flutter/material.dart';

import '../../data/mock_repository.dart';
import '../../theme/app_theme.dart';

/// Opens a themed date picker then a scroll-wheel time picker; returns combined [DateTime].
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

  final pickedTime = await _showScrollTimePicker(
    context,
    initialTime: TimeOfDay.fromDateTime(initial ?? seed),
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

Future<TimeOfDay?> _showScrollTimePicker(
  BuildContext context, {
  required TimeOfDay initialTime,
}) {
  return showDialog<TimeOfDay>(
    context: context,
    builder: (context) => _ScrollTimePickerDialog(initialTime: initialTime),
  );
}

class _ScrollTimePickerDialog extends StatefulWidget {
  const _ScrollTimePickerDialog({required this.initialTime});

  final TimeOfDay initialTime;

  @override
  State<_ScrollTimePickerDialog> createState() => _ScrollTimePickerDialogState();
}

class _ScrollTimePickerDialogState extends State<_ScrollTimePickerDialog> {
  static const _itemExtent = 44.0;
  static const _wheelHeight = 200.0;

  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _periodController;

  late int _hour12;
  late int _minute;
  late bool _isPm;

  @override
  void initState() {
    super.initState();
    final t = widget.initialTime;
    _isPm = t.period == DayPeriod.pm;
    _hour12 = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    _minute = t.minute;

    _hourController = FixedExtentScrollController(initialItem: _hour12 - 1);
    _minuteController = FixedExtentScrollController(initialItem: _minute);
    _periodController = FixedExtentScrollController(initialItem: _isPm ? 1 : 0);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  TimeOfDay get _selectedTime {
    final hour24 = _hour12 == 12
        ? (_isPm ? 12 : 0)
        : (_isPm ? _hour12 + 12 : _hour12);
    return TimeOfDay(hour: hour24, minute: _minute);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Select time',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: _wheelHeight,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: _itemExtent,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.gold.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(child: _wheel(
                          controller: _hourController,
                          count: 12,
                          selectedIndex: _hour12 - 1,
                          label: (i) => '${i + 1}',
                          onChanged: (i) => setState(() => _hour12 = i + 1),
                        )),
                        const Text(
                          ':',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(child: _wheel(
                          controller: _minuteController,
                          count: 60,
                          selectedIndex: _minute,
                          label: (i) => i.toString().padLeft(2, '0'),
                          onChanged: (i) => setState(() => _minute = i),
                        )),
                        Expanded(child: _wheel(
                          controller: _periodController,
                          count: 2,
                          selectedIndex: _isPm ? 1 : 0,
                          label: (i) => i == 0 ? 'AM' : 'PM',
                          onChanged: (i) => setState(() => _isPm = i == 1),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, _selectedTime),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wheel({
    required FixedExtentScrollController controller,
    required int count,
    required int selectedIndex,
    required String Function(int index) label,
    required ValueChanged<int> onChanged,
  }) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: _itemExtent,
      diameterRatio: 1.6,
      perspective: 0.003,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: onChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: count,
        builder: (context, index) {
          final selected = selectedIndex == index;
          return Center(
            child: Text(
              label(index),
              style: TextStyle(
                color: selected ? AppColors.gold : AppColors.textSecondary,
                fontSize: selected ? 20 : 16,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          );
        },
      ),
    );
  }
}
