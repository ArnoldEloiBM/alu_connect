import 'package:flutter/material.dart';
import '../data/mock_repository.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../utils/page_transitions.dart';
import '../widgets/category_card.dart';
import '../widgets/opportunity_cards.dart';
import '../widgets/section_header.dart';
import 'event_details_screen.dart';

/// Events tab — categories, featured opportunities carousel, and discussions.
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _repo = MockRepository.instance;
  final _featuredController = PageController(viewportFraction: 0.95);

  @override
  void dispose() {
    _featuredController.dispose();
    super.dispose();
  }

  void _openDetails(Opportunity o) {
    Navigator.of(context).push(
      smoothTransition(EventDetailsScreen(opportunity: o)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final featured = _repo.trending;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: const Text(
          'Events',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          children: _buildDiscoverContent(featured),
        ),
      ),
    );
  }

  List<Widget> _buildDiscoverContent(List<Opportunity> featured) {
    return [
      // Categories
      SectionHeader(title: 'Categories', actionLabel: 'View All', onAction: () {}),
      const SizedBox(height: 12),
      for (final c in _repo.categories)
        CategoryCard(category: c, onTap: () {}),
      const SizedBox(height: 12),

      // Featured Opportunities carousel
      SectionHeader(
        title: 'Featured Opportunities',
        trailing: Row(
          children: [
            _arrow(Icons.chevron_left, () => _nudge(-1)),
            const SizedBox(width: 4),
            _arrow(Icons.chevron_right, () => _nudge(1)),
          ],
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 230,
        child: PageView.builder(
          controller: _featuredController,
          itemCount: featured.length,
          itemBuilder: (context, i) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: DetailedOpportunityCard(
              opportunity: featured[i],
              onTap: () => _openDetails(featured[i]),
            ),
          ),
        ),
      ),
      const SizedBox(height: 24),

      // Trending Discussions
      SectionHeader(title: 'Trending Discussions'),
      const SizedBox(height: 12),
      _discussionTile(_repo.discussions.first),
      const SizedBox(height: 12),
      Row(
        children: [
          for (final d in _repo.discussions.skip(1))
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _discussionChip(d),
              ),
            ),
        ],
      ),
    ];
  }

  void _nudge(int direction) {
    final page = (_featuredController.page ?? 0).round() + direction;
    final count = _repo.trending.length;
    if (page < 0 || page >= count) return;
    _featuredController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget _arrow(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 18),
      ),
    );
  }

  Widget _discussionTile(Discussion d) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.trending_up, color: AppColors.gold),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  d.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '+${d.participants} others discussing',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _discussionChip(Discussion d) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.forum_outlined, color: AppColors.gold, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              d.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

