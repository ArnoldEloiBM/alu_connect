import 'package:flutter/material.dart';

import '../data/mock_repository.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../utils/page_transitions.dart';
import '../widgets/opportunity_cards.dart';
import '../widgets/search_field.dart';
import '../widgets/section_header.dart';
import 'event_details_screen.dart';

/// Full-screen search opened from the Home app bar.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _repo = MockRepository.instance;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDetails(Opportunity o) {
    Navigator.of(context).push(
      smoothTransition(EventDetailsScreen(opportunity: o)),
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
    final trimmed = _query.trim();
    final results = trimmed.isNotEmpty ? _repo.search(_query) : const <Opportunity>[];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: SearchField(
          controller: _searchController,
          onChanged: (v) => setState(() => _query = v),
          onFilterTap: _openFilterSheet,
          hint: 'Search events, clubs, or members...',
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            if (trimmed.isEmpty)
              Container(
                padding: const EdgeInsets.all(40),
                alignment: Alignment.center,
                child: const Text(
                  'Search for events, hackathons, internships, and more.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
              )
            else ...[
              SectionHeader(title: 'Results (${results.length})'),
              const SizedBox(height: 12),
              if (results.isEmpty)
                Container(
                  padding: const EdgeInsets.all(40),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.search_off, size: 64, color: AppColors.gold),
                      const SizedBox(height: 20),
                      const Text(
                        'No results found',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'for "$_query"',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              else
                for (final o in results)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: DetailedOpportunityCard(
                      opportunity: o,
                      onTap: () => _openDetails(o),
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}

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
