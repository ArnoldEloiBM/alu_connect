import 'package:flutter/material.dart';

import '../features/profile/screens/profile.dart';
import '../theme/app_theme.dart';
import 'community_list_screen.dart';
import 'events/create_event_screen.dart';
import 'events/my_events_screen.dart';
import 'home_screen.dart';
import 'messages_screen.dart';

/// App scaffold with bottom navigation.
class MainShell extends StatefulWidget {
  final ValueChanged<bool> onDarkModeToggle;

  const MainShell({super.key, required this.onDarkModeToggle});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _openCreateEvent() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CreateEventScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const HomeScreen(),
      const CommunityListScreen(),
      const MyEventsScreen(),
      const MessagesScreen(),
      ProfileScreen(onDarkModeToggle: widget.onDarkModeToggle),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: tabs),
      floatingActionButton: _index == 2
          ? null
          : FloatingActionButton(
              heroTag: 'main-shell-fab',
              onPressed: _openCreateEvent,
              tooltip: 'Create event',
              child: const Icon(Icons.add),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.gold,
        unselectedItemColor: AppColors.textSecondary,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.groups_outlined), label: 'Clubs'),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
