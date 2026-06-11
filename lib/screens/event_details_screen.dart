import 'package:flutter/material.dart';

import '../data/mock_repository.dart';
import '../models/models.dart';
import '../services/event_service.dart';
import '../services/user_session.dart';
import '../theme/app_theme.dart';
import '../utils/date_utils.dart';
import '../widgets/app_image.dart';
import '../widgets/events/organizer_event_actions.dart';
import '../widgets/events/rsvp_button.dart';

/// Event details with RSVP, save, and organizer postpone/cancel actions.
class EventDetailsScreen extends StatelessWidget {
  final Opportunity opportunity;

  const EventDetailsScreen({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context) {
    final now = MockRepository.instance.today;
    final service = EventService.instance;

    return Scaffold(
      body: ListenableBuilder(
        listenable: Listenable.merge([service, UserSession.instance]),
        builder: (context, _) {
          final event =
              service.opportunityById(opportunity.id) ?? opportunity;
          final saved = service.isSaved(event.id);
          final rsvped = service.isRsvped(event.id);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 240,
                pinned: true,
                backgroundColor: AppColors.background,
                actions: [
                  IconButton(
                    tooltip: saved ? 'Remove from saved' : 'Save event',
                    onPressed: () async {
                      await service.toggleSave(event.id);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            saved ? 'Removed from saved' : 'Event saved',
                          ),
                          backgroundColor: AppColors.surfaceAlt,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: Icon(
                      saved ? Icons.bookmark : Icons.bookmark_border,
                      color: saved ? AppColors.gold : AppColors.textPrimary,
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      AppImage(url: event.imageUrl),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.3),
                              AppColors.background,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _typeTag(event.type.label.toUpperCase()),
                          if (event.status != EventStatus.active)
                            _statusBadge(event.status.label, event.status),
                          if (rsvped) _statusBadge('Registered', null),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        event.subtitle,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _infoRow(Icons.access_time, 'Date & time',
                          prettyDateTime(event.deadline)),
                      _infoRow(Icons.timelapse, 'Status',
                          endsIn(event.deadline, now)),
                      if (event.organizer.isNotEmpty)
                        _infoRow(Icons.business, 'Organizer', event.organizer),
                      if (event.location.isNotEmpty)
                        _infoRow(Icons.place_outlined, 'Location', event.location),
                      if (event.score != null)
                        _infoRow(Icons.bolt, 'Impact Score',
                            event.score.toString()),
                      const SizedBox(height: 20),
                      const Text(
                        'About',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: RsvpButton(opportunity: event),
                      ),
                      const SizedBox(height: 24),
                      OrganizerEventActions(opportunity: event),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _typeTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.gold,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _statusBadge(String label, EventStatus? status) {
    final color = switch (status) {
      EventStatus.cancelled => AppColors.danger,
      EventStatus.postponed => AppColors.gold,
      EventStatus.active || null => const Color(0xFF4ADE80),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold, size: 18),
          const SizedBox(width: 10),
          Text(
            '$label:  ',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
