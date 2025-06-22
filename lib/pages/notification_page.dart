import 'package:flutter/material.dart';
import 'package:gietsmart/home_page.dart';

import 'downloads_page.dart';
import 'profile_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _selectedIndex = 2; // Notifications tab index

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const MyHomePage(title: 'GIET Smart')),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DownloadsPage()),
        );
        break;
      case 2:
        // Already on Notifications page
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F0F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF4A2D8B),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Mark all notifications as read
              setState(() {
                for (var notification in notifications) {
                  notification.isRead = true;
                }
              });
            },
            child: const Text(
              'Mark all as read',
              style: TextStyle(
                color: Color(0xFF4A2D8B),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Dismissible(
            key: Key(notification.id),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                notifications.removeAt(index);
              });
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Stack(
                  children: [
                    Icon(
                      notification.icon,
                      color: const Color(0xFF4A2D8B),
                      size: 28,
                    ),
                    if (!notification.isRead)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
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
                    Text(notification.message),
                    const SizedBox(height: 4),
                    Text(
                      notification.time,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    notification.isRead = true;
                  });
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4A2D8B),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.download),
            label: 'Downloads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class Notification {
  final String id;
  final String title;
  final String message;
  final String time;
  final IconData icon;
  bool isRead;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    this.isRead = false,
  });
}

final List<Notification> notifications = [
  Notification(
    id: '1',
    title: 'ID Card Ready',
    message: 'Your student ID card is ready for collection',
    time: '2 hours ago',
    icon: Icons.credit_card,
  ),
  Notification(
    id: '2',
    title: 'Bus Pass Updated',
    message: 'Your bus pass has been successfully updated',
    time: '5 hours ago',
    icon: Icons.directions_bus,
  ),
  Notification(
    id: '3',
    title: 'Project Uploaded',
    message: 'Your project files have been uploaded successfully',
    time: '1 day ago',
    icon: Icons.upload_file,
    isRead: true,
  ),
];
