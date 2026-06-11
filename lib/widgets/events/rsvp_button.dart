import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../services/event_service.dart';
import '../../theme/app_theme.dart';

/// Gold RSVP button with Attending / Closed states (Member 4).
class RsvpButton extends StatelessWidget {
  final Opportunity opportunity;
  final bool compact;
  final VoidCallback? onRsvpSuccess;

  const RsvpButton({
    super.key,
    required this.opportunity,
    this.compact = false,
    this.onRsvpSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: EventService.instance,
      builder: (context, _) => _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    final service = EventService.instance;
    final rsvped = service.isRsvped(opportunity.id);
    final open = service.isRegistrationOpen(opportunity);

    if (!open) {
      return _button(
        context,
        label: 'Closed',
        enabled: false,
        style: _ButtonStyle.muted,
      );
    }

    if (rsvped) {
      return _button(
        context,
        label: compact ? 'Attending' : 'Attending ✓',
        enabled: true,
        style: _ButtonStyle.outlined,
        onPressed: () => _confirmCancel(context),
      );
    }

    return _button(
      context,
      label: 'RSVP Now',
      enabled: true,
      style: _ButtonStyle.gold,
      onPressed: () => _handleRsvp(context),
    );
  }

  Future<void> _handleRsvp(BuildContext context) async {
    final ok = await EventService.instance.rsvp(opportunity.id);
    if (!context.mounted) return;
    if (ok) {
      onRsvpSuccess?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You\'re registered for ${opportunity.title}'),
          backgroundColor: AppColors.surfaceAlt,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _confirmCancel(BuildContext context) async {
    final cancel = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Cancel RSVP?',
            style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          'You will lose your spot for ${opportunity.title}.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep spot'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cancel RSVP',
                style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );

    if (cancel == true && context.mounted) {
      await EventService.instance.cancelRsvp(opportunity.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('RSVP cancelled'),
          backgroundColor: AppColors.surfaceAlt,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _button(
    BuildContext context, {
    required String label,
    required bool enabled,
    required _ButtonStyle style,
    VoidCallback? onPressed,
  }) {
    final padding = compact
        ? const EdgeInsets.symmetric(horizontal: 18, vertical: 10)
        : const EdgeInsets.symmetric(horizontal: 24, vertical: 14);

    switch (style) {
      case _ButtonStyle.gold:
        return ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: Colors.black,
            disabledBackgroundColor: AppColors.surfaceAlt,
            disabledForegroundColor: AppColors.textSecondary,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(compact ? 10 : 12),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      case _ButtonStyle.outlined:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.gold,
            side: const BorderSide(color: AppColors.gold),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(compact ? 10 : 12),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      case _ButtonStyle.muted:
        return ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: AppColors.surfaceAlt,
            disabledForegroundColor: AppColors.textSecondary,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(compact ? 10 : 12),
            ),
          ),
          child: Text(label),
        );
    }
  }
}

enum _ButtonStyle { gold, outlined, muted }
