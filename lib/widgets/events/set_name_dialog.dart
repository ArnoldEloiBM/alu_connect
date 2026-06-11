import 'package:flutter/material.dart';

import '../../services/user_session.dart';
import '../../theme/app_theme.dart';

/// Prompts the student to set the name shown as event organizer.
Future<bool> ensureUserName(BuildContext context) async {
  if (UserSession.instance.hasProfileName) return true;

  final controller = TextEditingController();
  final saved = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text(
        'Your name',
        style: TextStyle(color: AppColors.textPrimary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter the name that should appear as the event organizer.',
            style: TextStyle(color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'e.g. Laura Karangwa',
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surfaceAlt,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (controller.text.trim().length < 2) return;
            Navigator.pop(ctx, true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: Colors.black,
          ),
          child: const Text('Save'),
        ),
      ],
    ),
  );

  if (saved == true && controller.text.trim().length >= 2) {
    await UserSession.instance.setDisplayName(controller.text);
    controller.dispose();
    return true;
  }

  controller.dispose();
  return false;
}

/// Edit the logged-in display name from My Events.
Future<void> showEditNameDialog(BuildContext context) async {
  final controller =
      TextEditingController(text: UserSession.instance.displayName);
  final saved = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text(
        'Logged-in as',
        style: TextStyle(color: AppColors.textPrimary),
      ),
      content: TextField(
        controller: controller,
        autofocus: true,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: 'Your name',
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          filled: true,
          fillColor: AppColors.surfaceAlt,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (controller.text.trim().length < 2) return;
            Navigator.pop(ctx, true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: Colors.black,
          ),
          child: const Text('Update'),
        ),
      ],
    ),
  );

  if (saved == true && controller.text.trim().length >= 2) {
    await UserSession.instance.setDisplayName(controller.text);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signed in as ${UserSession.instance.displayName}'),
          backgroundColor: AppColors.surfaceAlt,
        ),
      );
    }
  }
  controller.dispose();
}
