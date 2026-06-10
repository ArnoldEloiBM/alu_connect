import 'package:flutter/material.dart';
import '../data/mock_repository.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/category_card.dart';
import '../widgets/opportunity_cards.dart';
import '../widgets/search_field.dart';
import '../widgets/section_header.dart';
import 'event_details_screen.dart';

/// Screen 2 — Discovery: search, categories, featured opportunities carousel
/// and trending discussions. When the search box is non-empty it switches to
/// showing live search results.
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _repo = MockRepository.instance;
  final _searchController = TextEditingController();
  final _featuredController = PageController(viewportFraction: 0.95);

  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    _featuredController.dispose();
    super.dispose();
  }

  void _openDetails(Opportunity o) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => EventDetailsScreen(opportunity: o)),
    );
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _FilterSheet(
        onSelect: (type) {
          Navigator.pop(context);
          setState(() {
            _query = type?.label ?? '';
            _searchController.text = _query;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = _query.trim().isNotEmpty;
    final results = isSearching ? _repo.search(_query) : const <Opportunity>[];
    final featured = _repo.trending;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: const Text(
          'ALU Connect',
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
          children: [
            SearchField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              onFilterTap: _openFilterSheet,
            ),
            const SizedBox(height: 20),

            if (isSearching)
              ..._buildSearchResults(results)
            else
              ..._buildDiscoverContent(featured),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSearchResults(List<Opportunity> results) {
    return [
      SectionHeader(title: 'Results (${results.length})'),
      const SizedBox(height: 12),
      if (results.isEmpty)
        Container(
          padding: const EdgeInsets.all(24),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            'No results for "$_query"',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        )
      else
        for (final o in results)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: DetailedOpportunityCard(
              opportunity: o,
              onTap: () => _openDetails(o),
              onRsvp: () => _openDetails(o),
            ),
          ),
    ];
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
              onRsvp: () => _openDetails(featured[i]),
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

/// Bottom sheet listing opportunity types to filter discovery by.
class _FilterSheet extends StatelessWidget {
  final ValueChanged<OpportunityType?> onSelect;
  const _FilterSheet({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Filter by type',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.clear_all, color: AppColors.textPrimary),
              title: const Text('All',
                  style: TextStyle(color: AppColors.textPrimary)),
              onTap: () => onSelect(null),
            ),
            for (final t in OpportunityType.values)
              ListTile(
                leading: const Icon(Icons.label_outline,
                    color: AppColors.textPrimary),
                title: Text(t.label,
                    style: const TextStyle(color: AppColors.textPrimary)),
                onTap: () => onSelect(t),
              ),
          ],
        ),
      ),
    );
  }
}
