import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<AppNotification> _notifications = [
    AppNotification(
      title: 'ID Card Ready',
      message: 'Your Student ID Card is ready for collection',
      type: NotificationType.idCard,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    AppNotification(
      title: 'Project Upload Successful',
      message:
          'Your project "Flutter App Development" has been uploaded successfully',
      type: NotificationType.project,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
    ),
    AppNotification(
      title: 'New Event',
      message: 'Technical Symposium registration starts tomorrow',
      type: NotificationType.event,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
    ),
  ];

  void _markAsRead(int index) {
    setState(() {
      _notifications[index].isRead = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F0F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF4A2D8B),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF4A2D8B),
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                for (var notification in _notifications) {
                  notification.isRead = true;
                }
              });
            },
            icon: const Icon(Icons.done_all, color: Color(0xFF4A2D8B)),
            label: const Text(
              'Mark all as read',
              style: TextStyle(color: Color(0xFF4A2D8B)),
            ),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return Dismissible(
                  key: Key(notification.timestamp.toString()),
                  background: Container(
                    color: Colors.red.shade100,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      _notifications.removeAt(index);
                    });
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: notification.isRead
                        ? Colors.white
                        : const Color(0xFFEDE7F6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(
                          0xFF4A2D8B,
                        ).withOpacity(0.1),
                        child: Icon(
                          notification.type.icon,
                          color: const Color(0xFF4A2D8B),
                        ),
                      ),
                      title: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: notification.isRead
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(notification.message),
                          const SizedBox(height: 4),
                          Text(
                            notification.formattedTime,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      onTap: () => _markAsRead(index),
                      trailing: notification.isRead
                          ? null
                          : const Icon(
                              Icons.circle,
                              size: 12,
                              color: Color(0xFF4A2D8B),
                            ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

enum NotificationType {
  idCard(Icons.credit_card),
  project(Icons.file_present),
  event(Icons.event);

  const NotificationType(this.icon);
  final IconData icon;
}

class AppNotification {
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  bool isRead;

  AppNotification({
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });

  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
