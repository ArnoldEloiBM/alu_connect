import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'discover_screen.dart';
import 'home_screen.dart';

/// App scaffold that hosts the bottom navigation. Home (index 0) and Search
/// (index 2) are owned by Member 2; the other tabs are placeholders that
/// teammates will fill in.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  late final List<Widget> _tabs = const [
    HomeScreen(),
    _Placeholder(label: 'Clubs', icon: Icons.groups),
    DiscoverScreen(),
    _Placeholder(label: 'Messages', icon: Icons.chat_bubble_outline),
    _Placeholder(label: 'Profile', icon: Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: 'Messages'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

/// Simple stand-in for tabs owned by other team members.
class _Placeholder extends StatelessWidget {
  final String label;
  final IconData icon;
  const _Placeholder({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            Text(
              '$label — coming soon',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
