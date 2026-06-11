import 'package:flutter/material.dart';
import '../widgets/settings.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeToggle;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeToggle,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _darkMode;
  bool _eventReminders = true;
  bool _messageNotifs = true;
  bool _communityUpdates = false;

  @override
  void initState() {
    super.initState();
    _darkMode = widget.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    // All colors adapt to current theme automatically
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = isDark ? const Color(0xFF1B2B4B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0D1B2A);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0D1B2A) : Colors.white,
        elevation: 0,
        title: Text('Settings', style: TextStyle(color: textColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Appearance ──────────────────────────────────
          _buildSectionHeader('Appearance'),
          _buildCard(
            cardColor: cardColor,
            child: SettingsToggle(
              label: 'Dark Mode',
              subtitle: 'Switch between light and dark theme',
              value: _darkMode,
              onChanged: (val) {
                setState(() => _darkMode = val);
                // Bubbles up to main.dart to change the whole app theme
                widget.onDarkModeToggle(val);
              },
            ),
          ),

          const SizedBox(height: 20),

          // ── Notifications ───────────────────────────────
          _buildSectionHeader('Notifications'),
          _buildCard(
            cardColor: cardColor,
            child: Column(
              children: [
                SettingsToggle(
                  label: 'Event Reminders',
                  value: _eventReminders,
                  onChanged: (val) =>
                      setState(() => _eventReminders = val),
                ),
                Divider(
                    color: isDark
                        ? const Color(0xFF2E3D5C)
                        : Colors.grey.shade200,
                    height: 24),
                SettingsToggle(
                  label: 'Direct Messages',
                  value: _messageNotifs,
                  onChanged: (val) =>
                      setState(() => _messageNotifs = val),
                ),
                Divider(
                    color: isDark
                        ? const Color(0xFF2E3D5C)
                        : Colors.grey.shade200,
                    height: 24),
                SettingsToggle(
                  label: 'Community Updates',
                  value: _communityUpdates,
                  onChanged: (val) =>
                      setState(() => _communityUpdates = val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Account ─────────────────────────────────────
          _buildSectionHeader('Account'),
          _buildCard(
            cardColor: cardColor,
            child: Column(
              children: [
                _buildAccountRow(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: 'charlotte@alueducation.com',
                  textColor: textColor,
                ),
                Divider(
                    color: isDark
                        ? const Color(0xFF2E3D5C)
                        : Colors.grey.shade200,
                    height: 24),
                _buildAccountRow(
                  icon: Icons.lock_outlined,
                  label: 'Change Password',
                  value: '',
                  textColor: textColor,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ── Log Out ─────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (_) => false);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFFF6B6B),
                side: const BorderSide(color: Color(0xFFFF6B6B)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Log Out', style: TextStyle(fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFF5B800),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child, required Color cardColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _buildAccountRow({
    required IconData icon,
    required String label,
    required String value,
    required Color textColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFF5B800), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label,
              style: TextStyle(color: textColor, fontSize: 14)),
        ),
        Text(value,
            style: TextStyle(
                color: textColor.withOpacity(0.4), fontSize: 13)),
        Icon(Icons.chevron_right,
            color: textColor.withOpacity(0.3), size: 18),
      ],
    );
  }
}