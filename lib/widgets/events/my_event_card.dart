import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../services/event_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_utils.dart';
import '../app_image.dart';

enum MyEventStatus { attending, saved, organizing }

/// Card for My Events lists with optional like-to-save on Attending tab.
class MyEventCard extends StatelessWidget {
  final Opportunity opportunity;
  final MyEventStatus status;
  final int? attendeeCount;
  final bool showLikeButton;
  final VoidCallback? onTap;

  const MyEventCard({
    super.key,
    required this.opportunity,
    required this.status,
    this.attendeeCount,
    this.showLikeButton = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: EventService.instance,
      builder: (context, _) {
        final liked = EventService.instance.isSaved(opportunity.id);

        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Row(
              children: [
                SizedBox(
                  width: 96,
                  height: 96,
                  child: AppImage(url: opportunity.imageUrl),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _statusChip(),
                            if (opportunity.status != EventStatus.active) ...[
                              const SizedBox(width: 6),
                              _eventStatusChip(),
                            ],
                            const Spacer(),
                            Text(
                              opportunity.type.label.toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          opportunity.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          prettyDateTime(opportunity.deadline),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        if (attendeeCount != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            '$attendeeCount registered',
                            style: const TextStyle(
                              color: AppColors.gold,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (showLikeButton)
                      IconButton(
                        tooltip: liked ? 'Saved' : 'Save to Saved tab',
                        onPressed: () async {
                          await EventService.instance.toggleSave(opportunity.id);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                liked
                                    ? 'Removed from Saved'
                                    : 'Added to Saved events',
                              ),
                              backgroundColor: AppColors.surfaceAlt,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: Icon(
                          liked ? Icons.favorite : Icons.favorite_border,
                          color: liked ? AppColors.gold : AppColors.textSecondary,
                        ),
                      ),
                    const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(
                        Icons.chevron_right,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statusChip() {
    final (label, color) = switch (status) {
      MyEventStatus.attending => ('Attending', AppColors.gold),
      MyEventStatus.saved => ('Saved', AppColors.textSecondary),
      MyEventStatus.organizing => ('Organizing', const Color(0xFF4ADE80)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _eventStatusChip() {
    final color = opportunity.status == EventStatus.cancelled
        ? AppColors.danger
        : AppColors.gold;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        opportunity.status.label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
