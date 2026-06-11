import 'package:flutter/material.dart';

class NotificationItem {
  final String title;
  final String body;
  final String time;
  final IconData icon;
  bool isRead;

  NotificationItem({
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'RSVP Confirmed',
      body: 'Your spot at Kigali Tech Summit is confirmed.',
      time: '2 min ago',
      icon: Icons.event_available,
    ),
    NotificationItem(
      title: 'New Message',
      body: 'Amina J. sent you a message in Campus Leaders.',
      time: '1 hour ago',
      icon: Icons.message_outlined,
      isRead: true,
    ),
    NotificationItem(
      title: 'New Opportunity',
      body: 'Google Internship — Product Design is now open.',
      time: 'Yesterday',
      icon: Icons.work_outline,
    ),
    NotificationItem(
      title: 'Badge Earned',
      body: 'You earned the "Top Contributor" badge!',
      time: '2 days ago',
      icon: Icons.emoji_events_outlined,
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = isDark ? const Color(0xFF1B2B4B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0D1B2A);
    final subColor = isDark ? Colors.white54 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0D1B2A) : Colors.white,
        elevation: 0,
        title: Text('Notifications', style: TextStyle(color: textColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined,
                      color: subColor, size: 60),
                  const SizedBox(height: 12),
                  Text('No notifications yet',
                      style: TextStyle(color: subColor, fontSize: 16)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => Divider(
                color: isDark
                    ? const Color(0xFF1B2B4B)
                    : Colors.grey.shade200,
              ),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return ListTile(
                  onTap: () {
                    setState(() => item.isRead = true);
                  },
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: cardColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item.icon,
                        color: const Color(0xFFF5B800), size: 20),
                  ),
                  title: Text(item.title,
                      style: TextStyle(color: textColor, fontSize: 14)),
                  subtitle: Text(item.body,
                      style: TextStyle(color: subColor, fontSize: 12)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item.time,
                          style: TextStyle(color: subColor, fontSize: 11)),
                      const SizedBox(height: 4),
                      if (!item.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5B800),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}