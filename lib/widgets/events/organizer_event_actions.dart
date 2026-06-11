import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../services/event_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_utils.dart';
import 'pick_date_time.dart';

/// Postpone and cancel controls for events the logged-in user created.
class OrganizerEventActions extends StatelessWidget {
  final Opportunity opportunity;

  const OrganizerEventActions({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context) {
    final service = EventService.instance;
    if (!service.isUserCreated(opportunity.id) ||
        !service.isOrganizer(opportunity)) {
      return const SizedBox.shrink();
    }

    if (opportunity.status == EventStatus.cancelled) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.danger.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.danger.withValues(alpha: 0.4)),
        ),
        child: const Text(
          'This event has been cancelled.',
          style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Organizer actions',
          style: TextStyle(
            color: AppColors.gold,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _postpone(context),
          icon: const Icon(Icons.schedule, color: AppColors.gold),
          label: const Text('Postpone event'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.gold,
            side: const BorderSide(color: AppColors.gold),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => _cancel(context),
          icon: const Icon(Icons.cancel_outlined, color: AppColors.danger),
          label: const Text('Cancel event'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.danger,
            side: const BorderSide(color: AppColors.danger),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _postpone(BuildContext context) async {
    final newDate = await pickEventDateTime(
      context,
      initial: opportunity.deadline,
      dateHelpText: 'Pick new event date',
    );
    if (newDate == null || !context.mounted) return;

    await EventService.instance.postponeEvent(opportunity.id, newDate);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Postponed to ${prettyDateTime(newDate)}'),
        backgroundColor: AppColors.surfaceAlt,
      ),
    );
  }

  Future<void> _cancel(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Cancel event?',
            style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          'Students will no longer be able to RSVP to "${opportunity.title}".',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep event'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cancel event',
                style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await EventService.instance.cancelEvent(opportunity.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event cancelled'),
          backgroundColor: AppColors.surfaceAlt,
        ),
      );
    }
  }
}
