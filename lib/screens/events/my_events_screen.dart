import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../services/event_service.dart';
import '../../theme/app_theme.dart';
import '../../services/user_session.dart';
import '../../widgets/events/empty_events_state.dart';
import '../../widgets/events/my_event_card.dart';
import '../../widgets/events/set_name_dialog.dart';
import '../event_details_screen.dart';
import 'create_event_screen.dart';
import 'organizer_dashboard_screen.dart';

/// My Events hub: Attending, Saved, and Organizing tabs (Member 4).
class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Events',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          ListenableBuilder(
            listenable: UserSession.instance,
            builder: (context, _) => IconButton(
              tooltip: 'Logged in as ${UserSession.instance.displayName}',
              onPressed: () => showEditNameDialog(context),
              icon: const Icon(Icons.person_outline),
            ),
          ),
          IconButton(
            tooltip: 'Organizer dashboard',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const OrganizerDashboardScreen(),
              ),
            ),
            icon: const Icon(Icons.dashboard_outlined),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.gold,
          labelColor: AppColors.gold,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'Attending'),
            Tab(text: 'Saved'),
            Tab(text: 'Organizing'),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: EventService.instance,
        builder: (context, _) {
          final service = EventService.instance;
          return TabBarView(
            controller: _tabController,
            children: [
              _EventList(
                events: service.attendingEvents,
                status: MyEventStatus.attending,
                showLikeButton: true,
                empty: const EmptyEventsState(
                  icon: Icons.event_available_outlined,
                  title: 'No events yet',
                  subtitle:
                      'RSVP from Home or Search, then tap the heart to save events you like.',
                ),
              ),
              _EventList(
                events: service.savedEvents,
                status: MyEventStatus.saved,
                empty: const EmptyEventsState(
                  icon: Icons.favorite_border,
                  title: 'Nothing saved',
                  subtitle:
                      'Tap the heart on events in Attending to keep them here.',
                ),
              ),
              _EventList(
                events: service.organizingEvents,
                status: MyEventStatus.organizing,
                showAttendees: true,
                empty: EmptyEventsState(
                  icon: Icons.add_circle_outline,
                  title: 'No events created',
                  subtitle:
                      'Club leaders and organizers can post opportunities for the ALU community.',
                  actionLabel: 'Create event',
                  onAction: () => _openCreate(context),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'my-events-fab',
        onPressed: () => _openCreate(context),
        icon: const Icon(Icons.add),
        label: const Text('Create'),
      ),
    );
  }

  void _openCreate(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CreateEventScreen()),
    );
  }
}

class _EventList extends StatelessWidget {
  final List<Opportunity> events;
  final MyEventStatus status;
  final Widget empty;
  final bool showAttendees;
  final bool showLikeButton;

  const _EventList({
    required this.events,
    required this.status,
    required this.empty,
    this.showAttendees = false,
    this.showLikeButton = false,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) return empty;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
      itemCount: events.length,
      itemBuilder: (context, i) {
        final event = events[i];
        return MyEventCard(
          opportunity: event,
          status: status,
          showLikeButton: showLikeButton,
          attendeeCount: showAttendees
              ? EventService.instance.attendeeCount(event.id)
              : null,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => EventDetailsScreen(opportunity: event),
            ),
          ),
        );
      },
    );
  }
}
