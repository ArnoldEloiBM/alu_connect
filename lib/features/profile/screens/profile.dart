import 'package:flutter/material.dart';
import '../models/user.dart';
import '../widgets/impact_score_bar.dart';
import '../widgets/achievement_badge.dart';
import 'edit.dart';
import 'notifications.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  final ValueChanged<bool> onDarkModeToggle;

  const ProfileScreen({super.key, required this.onDarkModeToggle});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User user;
  bool _isDarkMode = true;

  // Projects list in state so new ones can be added
  List<Map<String, dynamic>> projects = [
    {
      'title': 'Eco-Water Initiative',
      'description':
          'Providing sustainable clean water solutions for over 500 households in rural Kigali.',
      'fullDescription':
          'This project addresses the water crisis in rural Rwanda by deploying affordable solar-powered water filtration units. The initiative has served over 500 households and is expanding to 3 more districts in 2026.',
      'tags': ['Sustainability', 'Engineering'],
      'isFeatured': true,
      'imageUrl':
          'https://images.unsplash.com/photo-1541544537156-7627a7a4aa1c?w=600&q=80',
      'icon': Icons.water_drop,
    },
    {
      'title': 'ALU Learn App',
      'description':
          'Redesigning the peer-to-peer learning experience for ALU students.',
      'fullDescription':
          'A mobile app that connects ALU students for peer tutoring, resource sharing, and study group coordination. Built with React Native and Firebase, currently used by 300+ students across both campuses.',
      'tags': ['UI/UX', 'Mobile'],
      'isFeatured': false,
      'imageUrl':
          'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=600&q=80',
      'icon': Icons.school,
    },
  ];

  @override
  void initState() {
    super.initState();
    user = User(
      name: 'Umutoni Charlotte',
      major: 'Social Innovation & Entrepreneurship',
      campus: 'ALU Rwanda',
      classYear: 'Class of 2026',
      impactScore: 850,
      rankLabel: 'Ranked Top 6% Globally',
      nextLevel: 'Impact Titan',
      badges: ['Global Leader', 'Hacker Extra', 'Mentor', 'Top Contributor'],
      joinedHubs: ['Founders Circle', 'Tech Ventures'],
      eventsAttended: 23,
      communities: 5,
      connections: 87,
    );
  }

  // Get initials from full name
  String _getInitials(String name) {
    List<String> parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  // Map badge name to icon
  IconData _getBadgeIcon(String badge) {
    switch (badge) {
      case 'Global Leader':
        return Icons.public;
      case 'Hacker Extra':
        return Icons.code;
      case 'Mentor':
        return Icons.people;
      case 'Top Contributor':
        return Icons.star;
      default:
        return Icons.emoji_events;
    }
  }

  // Opens detail bottom sheet for hubs and projects
  void _openDetailSheet({
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        isDark ? const Color(0xFF1B2B4B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0D1B2A);
    final subColor = isDark ? Colors.white54 : Colors.black54;

    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Icon and title row
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5B800),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon,
                        color: const Color(0xFF0D1B2A), size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(color: subColor, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                description,
                style: TextStyle(
                  color: subColor,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5B800),
                    foregroundColor: const Color(0xFF0D1B2A),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // Opens form to add a new project
  void _openAddProjectSheet() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1B2B4B) : Colors.white;
    final fieldColor =
        isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF0F2F5);
    final textColor = isDark ? Colors.white : const Color(0xFF0D1B2A);

    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'New Project',
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Title field
              TextField(
                controller: titleController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'Project Title',
                  labelStyle: TextStyle(color: textColor.withOpacity(0.5)),
                  filled: true,
                  fillColor: fieldColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Description field
              TextField(
                controller: descController,
                style: TextStyle(color: textColor),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: textColor.withOpacity(0.5)),
                  filled: true,
                  fillColor: fieldColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isNotEmpty) {
                      // Actually adds to the projects list and rebuilds
                      setState(() {
                        projects.add({
                          'title': titleController.text.trim(),
                          'description':
                              descController.text.trim().isEmpty
                                  ? 'No description provided.'
                                  : descController.text.trim(),
                          'fullDescription':
                              descController.text.trim().isEmpty
                                  ? 'No description provided.'
                                  : descController.text.trim(),
                          'tags': ['New'],
                          'isFeatured': false,
                          'imageUrl':
                              'https://images.unsplash.com/photo-1497366216548-37526070297c?w=600&q=80',
                          'icon': Icons.work_outline,
                        });
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '${titleController.text} added to portfolio!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5B800),
                    foregroundColor: const Color(0xFF0D1B2A),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Add Project',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // These adapt automatically to dark or light mode
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor =
        isDark ? const Color(0xFF1B2B4B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0D1B2A);
    final subColor = isDark ? Colors.white54 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,

      // ── App Bar ──────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0D1B2A) : Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFF5B800),
              child: Text(
                _getInitials(user.name),
                style: const TextStyle(
                  color: Color(0xFF0D1B2A),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'ALU Connect',
              style: TextStyle(color: textColor, fontSize: 16),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: textColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const NotificationsScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined, color: textColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(
                    isDarkMode: _isDarkMode,
                    onDarkModeToggle: (val) {
                      setState(() => _isDarkMode = val);
                      widget.onDarkModeToggle(val);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),

      // ── Body ─────────────────────────────────────────────
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(cardColor, textColor, subColor),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ImpactScoreBar(user: user),
            ),
            const SizedBox(height: 20),
            _buildStatsRow(cardColor, textColor, subColor),
            const SizedBox(height: 24),
            _buildAchievementBadges(textColor),
            const SizedBox(height: 24),
            _buildJoinedHubs(cardColor, textColor, subColor),
            const SizedBox(height: 24),
            _buildPortfolio(textColor, subColor),
            const SizedBox(height: 30),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNavBar(isDark),
    );
  }

  // ── Profile Header ───────────────────────────────────────
  Widget _buildProfileHeader(
      Color cardColor, Color textColor, Color subColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        children: [
          // Avatar with green online dot
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFF1B2B4B),
                child: Text(
                  _getInitials(user.name),
                  style: const TextStyle(
                    color: Color(0xFFF5B800),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Text(
            user.name,
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),

          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF5B800),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user.classYear,
              style: const TextStyle(
                color: Color(0xFF0D1B2A),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),

          Text(
            '${user.major} @ ${user.campus}',
            style: TextStyle(color: subColor, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Edit profile button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final updatedUser = await Navigator.push<User>(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EditProfileScreen(user: user)),
                );
                if (updatedUser != null) {
                  setState(() => user = updatedUser);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5B800),
                foregroundColor: const Color(0xFF0D1B2A),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats Row ────────────────────────────────────────────
  Widget _buildStatsRow(
      Color cardColor, Color textColor, Color subColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStat(
                user.eventsAttended.toString(), 'Events', textColor, subColor),
            Container(width: 1, height: 30, color: Colors.grey.withOpacity(0.3)),
            _buildStat(
                user.communities.toString(), 'Communities', textColor, subColor),
            Container(width: 1, height: 30, color: Colors.grey.withOpacity(0.3)),
            _buildStat(
                user.connections.toString(), 'Connections', textColor, subColor),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(
      String value, String label, Color textColor, Color subColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: subColor, fontSize: 12)),
      ],
    );
  }

  // ── Achievement Badges ───────────────────────────────────
  Widget _buildAchievementBadges(Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Achievement Badges',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF1B2B4B)
                            : Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'All Badges',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: user.badges.map((badge) {
                                return AchievementBadge(
                                  label: badge,
                                  icon: _getBadgeIcon(badge),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                      color: Color(0xFFF5B800), fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: user.badges.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: 20),
              itemBuilder: (context, index) {
                return AchievementBadge(
                  label: user.badges[index],
                  icon: _getBadgeIcon(user.badges[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Joined Hubs ──────────────────────────────────────────
  Widget _buildJoinedHubs(
      Color cardColor, Color textColor, Color subColor) {
    final List<Map<String, dynamic>> hubs = [
      {
        'name': 'Founders Circle',
        'members': '240 Active Members',
        'challenges': '12 New Challenges',
        'description':
            'A community of student entrepreneurs building the next generation of African startups. Members get access to mentors, pitch events, and funding opportunities.',
        'imageUrl':
            'https://images.unsplash.com/photo-1556761175-5973dc0f32e7?w=600&q=80',
        'icon': Icons.rocket_launch,
      },
      {
        'name': 'Tech Ventures',
        'members': 'Community of 1.2k Innovators',
        'challenges': '',
        'description':
            'ALU\'s largest tech community. We build projects, host hackathons, and connect students with top tech companies across Africa and beyond.',
        'imageUrl':
            'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=600&q=80',
        'icon': Icons.computer,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Joined Hubs',
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          ...hubs.map((hub) {
            return GestureDetector(
              onTap: () {
                _openDetailSheet(
                  title: hub['name'] as String,
                  subtitle: hub['members'] as String,
                  description: hub['description'] as String,
                  icon: hub['icon'] as IconData,
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.hardEdge,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hub image from Unsplash
                    Image.network(
                      hub['imageUrl'] as String,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      // Shows a loading placeholder while image loads
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 120,
                          color: const Color(0xFF1B2B4B),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFF5B800),
                            ),
                          ),
                        );
                      },
                      // Shows a fallback if image fails to load
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          color: const Color(0xFF1B2B4B),
                          child: const Center(
                            child: Icon(Icons.image_outlined,
                                color: Colors.white24, size: 40),
                          ),
                        );
                      },
                    ),

                    // Hub info below image
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5B800),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              hub['icon'] as IconData,
                              color: const Color(0xFF0D1B2A),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hub['name'] as String,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  hub['members'] as String,
                                  style: TextStyle(
                                      color: subColor, fontSize: 12),
                                ),
                                if ((hub['challenges'] as String).isNotEmpty)
                                  Text(
                                    hub['challenges'] as String,
                                    style: const TextStyle(
                                      color: Color(0xFFF5B800),
                                      fontSize: 11,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              color: subColor, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Portfolio ────────────────────────────────────────────
  Widget _buildPortfolio(Color textColor, Color subColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Portfolio',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: _openAddProjectSheet,
                child: const Row(
                  children: [
                    Icon(Icons.add, color: Color(0xFFF5B800), size: 16),
                    Text(
                      ' New Project',
                      style: TextStyle(
                          color: Color(0xFFF5B800), fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Project cards — uses the state list so new ones appear
          ...projects.map((project) {
            return GestureDetector(
              onTap: () {
                _openDetailSheet(
                  title: project['title'] as String,
                  subtitle:
                      (project['tags'] as List<String>).join(' · '),
                  description: project['fullDescription'] as String,
                  icon: project['icon'] as IconData,
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF1B2B4B)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.hardEdge,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project image
                    Stack(
                      children: [
                        Image.network(
                          project['imageUrl'] as String,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 140,
                              color: const Color(0xFF0D2137),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFF5B800),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 140,
                              color: const Color(0xFF0D2137),
                              child: const Center(
                                child: Icon(Icons.image_outlined,
                                    color: Colors.white24, size: 48),
                              ),
                            );
                          },
                        ),
                        // Featured badge
                        if (project['isFeatured'] as bool)
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Featured',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    // Project details
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project['title'] as String,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            project['description'] as String,
                            style: TextStyle(
                                color: subColor, fontSize: 12),
                          ),
                          const SizedBox(height: 10),
                          // Tags
                          Wrap(
                            spacing: 8,
                            children: (project['tags'] as List<String>)
                                .map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? const Color(0xFF0D1B2A)
                                      : const Color(0xFFF0F2F5),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                      color: subColor, fontSize: 11),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Bottom Nav Bar ───────────────────────────────────────
  Widget _buildBottomNavBar(bool isDark) {
    return BottomNavigationBar(
      backgroundColor:
          isDark ? const Color(0xFF0D1B2A) : Colors.white,
      selectedItemColor: const Color(0xFFF5B800),
      unselectedItemColor: isDark ? Colors.white38 : Colors.black38,
      type: BottomNavigationBarType.fixed,
      currentIndex: 4,
      onTap: (index) {
        // Other tabs wired by teammates
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          activeIcon: Icon(Icons.people),
          label: 'Clubs',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message_outlined),
          activeIcon: Icon(Icons.message),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}