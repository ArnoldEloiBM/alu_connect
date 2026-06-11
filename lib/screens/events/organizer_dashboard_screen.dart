import 'package:flutter/material.dart';

import '../../services/event_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/events/empty_events_state.dart';
import '../../widgets/events/my_event_card.dart';
import '../event_details_screen.dart';
import 'create_event_screen.dart';

/// Organizer dashboard — stats and management for events you created (Member 4).
class OrganizerDashboardScreen extends StatelessWidget {
  const OrganizerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Organizer Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListenableBuilder(
        listenable: EventService.instance,
        builder: (context, _) {
          final service = EventService.instance;
          final events = service.organizingEvents;

          if (events.isEmpty) {
            return EmptyEventsState(
              icon: Icons.dashboard_outlined,
              title: 'No events to manage',
              subtitle:
                  'Create your first event to track registrations and engagement.',
              actionLabel: 'Create event',
              onAction: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CreateEventScreen()),
              ),
            );
          }

          final totalRsvps = events.fold<int>(
            0,
            (sum, e) => sum + service.attendeeCount(e.id),
          );
          final upcoming = events
              .where((e) => service.isRegistrationOpen(e))
              .length;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              const Text(
                'Overview',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Your events',
                      value: '${events.length}',
                      icon: Icons.event_note,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Total RSVPs',
                      value: '$totalRsvps',
                      icon: Icons.people_outline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _StatCard(
                label: 'Open for registration',
                value: '$upcoming',
                icon: Icons.how_to_reg_outlined,
                fullWidth: true,
              ),
              const SizedBox(height: 28),
              const Text(
                'Your events',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              for (final event in events)
                MyEventCard(
                  opportunity: event,
                  status: MyEventStatus.organizing,
                  attendeeCount: service.attendeeCount(event.id),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EventDetailsScreen(opportunity: event),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CreateEventScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool fullWidth;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.gold, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
