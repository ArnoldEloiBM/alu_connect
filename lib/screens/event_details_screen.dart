import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../utils/date_utils.dart';
import '../widgets/app_image.dart';
import '../data/mock_repository.dart';

/// Event / Opportunity Details screen — tapped through from any card.
class EventDetailsScreen extends StatelessWidget {
  final Opportunity opportunity;

  const EventDetailsScreen({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context) {
    final now = MockRepository.instance.today;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  AppImage(url: opportunity.imageUrl),
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
                  _typeTag(opportunity.type.label.toUpperCase()),
                  const SizedBox(height: 12),
                  Text(
                    opportunity.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    opportunity.subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _infoRow(Icons.access_time, 'Deadline',
                      prettyDate(opportunity.deadline)),
                  _infoRow(Icons.timelapse, 'Status',
                      endsIn(opportunity.deadline, now)),
                  if (opportunity.organizer.isNotEmpty)
                    _infoRow(Icons.business, 'Organizer', opportunity.organizer),
                  if (opportunity.location.isNotEmpty)
                    _infoRow(Icons.place_outlined, 'Location',
                        opportunity.location),
                  if (opportunity.score != null)
                    _infoRow(Icons.bolt, 'Impact Score',
                        opportunity.score.toString()),
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
                    opportunity.description,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('RSVP\'d to ${opportunity.title}'),
                            backgroundColor: AppColors.surfaceAlt,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'RSVP Now',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
