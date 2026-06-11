import 'package:flutter/material.dart';
import '../data/mock_repository.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../utils/page_transitions.dart';
import '../widgets/deadline_row.dart';
import '../widgets/filter_chips.dart';
import '../widgets/opportunity_cards.dart';
import '../widgets/section_header.dart';
import 'event_details_screen.dart';

/// Screen 1 — the dynamic Home feed: greeting, type filters, "Trending Now"
/// and "Upcoming Deadlines".
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repo = MockRepository.instance;
  OpportunityType? _filter; // null == "All"

  void _openDetails(Opportunity o) {
    Navigator.of(context).push(
      smoothTransition(EventDetailsScreen(opportunity: o)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAll = _filter == null;
    // "All" shows the curated home (trending hero + deadlines); a specific
    // chip shows every event of that type from the full catalogue.
    final trending = _repo.trending;
    final deadlines = _repo.deadlines;
    final filtered = _repo.filterByType(_filter);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.school, color: Colors.black, size: 18),
            ),
            const SizedBox(width: 8),
            const Text(
              'ALU Connect',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.notifications_none, size: 24),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            // Greeting
            Text(
              'Welcome back, ${_repo.greetingName}!',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'You have ${_repo.upcomingDeadlineCount} upcoming deadlines this week.',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),

            // Filter chips
            FilterChips(
              selected: _filter,
              onSelected: (t) => setState(() => _filter = t),
            ),
            const SizedBox(height: 20),

            if (isAll) ...[
              // ---- "All" view: the curated home feed --------------------
              SectionHeader(
                title: 'Trending Now',
                actionLabel: 'View All',
                onAction: () {},
              ),
              const SizedBox(height: 12),
              FeaturedOpportunityCard(
                opportunity: trending.first,
                now: _repo.today,
                onTap: () => _openDetails(trending.first),
              ),
              const SizedBox(height: 12),
              _trendingMiniRow(trending),
              const SizedBox(height: 24),

              SectionHeader(title: 'Upcoming Deadlines'),
              const SizedBox(height: 12),
              for (final d in deadlines.take(4))
                DeadlineRow(
                  deadline: d,
                  onTap: () {
                    final match = _repo.allOpportunities
                        .firstWhere((o) => o.id == d.id);
                    _openDetails(match);
                  },
                ),
            ] else ...[
              // ---- Filtered view: every event of the chosen type --------
              SectionHeader(title: '${_filter!.label}s (${filtered.length})'),
              const SizedBox(height: 12),
              if (filtered.isEmpty)
                _emptyState('No ${_filter!.label.toLowerCase()} events yet.')
              else
                for (final o in filtered)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: DetailedOpportunityCard(
                      opportunity: o,
                      onTap: () => _openDetails(o),
                      onRsvp: () => _openDetails(o),
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }

  /// The two secondary cards under the hero. Falls back to fixed "Impact
  /// Leaderboard" tile to match the design when only one trending item remains.
  Widget _trendingMiniRow(List<Opportunity> trending) {
    final second = trending.length > 1 ? trending[1] : null;
    return Row(
      children: [
        Expanded(
          child: second != null
              ? MiniOpportunityCard(
                  icon: Icons.work_outline,
                  title: second.title,
                  subtitle: second.subtitle,
                  onTap: () => _openDetails(second),
                )
              : const MiniOpportunityCard(
                  icon: Icons.work_outline,
                  title: 'Google Internship',
                  subtitle: 'Product Design',
                ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: MiniOpportunityCard(
            icon: Icons.emoji_events_outlined,
            title: 'Impact Leaderboard',
            subtitle: 'Top 5% this month',
          ),
        ),
      ],
    );
  }

  Widget _emptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        message,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
