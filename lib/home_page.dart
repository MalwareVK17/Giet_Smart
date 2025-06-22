import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/theme_provider.dart';
import 'student_id_registration_page.dart';
import 'profile_page.dart';
import 'pages/downloads_page.dart';
import 'project_upload_page.dart';
import 'notification_page.dart';
import 'student_id_upload_page.dart';
import 'bus_pass_registration_page.dart';
import 'student_certificates_booking_page.dart';
import 'pages/event_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final ThemeProvider _themeProvider = ThemeProvider();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleTheme() {
    setState(() {
      _themeProvider.toggleTheme();
    });
  }

  void _showHelpDesk() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Help Desk',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A2D8B),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.book, color: Color(0xFF4A2D8B)),
              title: const Text('User Manual'),
              onTap: () {
                // Implement user manual navigation
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.description, color: Color(0xFF4A2D8B)),
              title: const Text('Terms & Conditions'),
              onTap: () {
                // Implement terms navigation
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Theme(
        data: _themeProvider.themeData,
        child: DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.3,
          maxChildSize: 0.6,
          expand: false,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xFFE0E0E0),
                          border: Border.all(
                            color: const Color(0xFF4A2D8B),
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Image.asset(
                            'assets/images/default_profile.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text(
                                  'GS',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4A2D8B),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'User Name',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _themeProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '+91 1234567890',
                              style: TextStyle(
                                color: _themeProvider.isDarkMode
                                    ? Colors.white70
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _themeProvider.isDarkMode
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          color: _themeProvider.isDarkMode
                              ? const Color(0xFF9D84E3)
                              : const Color(0xFF4A2D8B),
                        ),
                        onPressed: _toggleTheme,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.help, color: Color(0xFF4A2D8B)),
                    title: const Text('Help Desk'),
                    onTap: () {
                      Navigator.pop(context);
                      _showHelpDesk();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _buildHomePage(),
      const DownloadsPage(),
      const NotificationPage(),
      const ProfilePage(),
    ];

    return Theme(
      data: _themeProvider.themeData,
      child: Scaffold(
        appBar: _selectedIndex == 3
            ? null
            : AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.asset(
                    'assets/images/gietlogo2.png',
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: _showProfileDrawer,
                  ),
                ],
              ),
        body: _pages[_selectedIndex],
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
      ),
    );
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome to GIET Smart',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A2D8B),
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildActionCard(
                'Student ID Registration',
                Icons.credit_card,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StudentIdRegistrationPage(),
                    ),
                  );
                },
              ),
              _buildActionCard(
                'Certificate Booking',
                Icons.description,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const StudentCertificatesBookingPage(),
                    ),
                  );
                },
              ),
              _buildActionCard(
                'Bus Pass Registration',
                Icons.directions_bus,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BusPassRegistrationPage(),
                    ),
                  );
                },
              ),
              _buildActionCard('Project Upload', Icons.file_upload, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProjectUploadPage(),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Upcoming Events',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A2D8B),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildEventCard(
                  'Technical Symposium',
                  'Annual technical event showcasing student projects',
                  'assets/images/technical.jpg',
                  'March 15, 2024',
                ),
                _buildEventCard(
                  'Sports Day',
                  'Annual sports competition',
                  'assets/images/sport.jpg',
                  'March 20, 2024',
                ),
                _buildEventCard(
                  'Cultural Fest',
                  'Cultural programs and performances',
                  'assets/images/culture.jpg',
                  'March 25, 2024',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, VoidCallback onTap) {
    return Theme(
      data: _themeProvider.themeData,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: _themeProvider.isDarkMode
                      ? const Color(0xFF9D84E3)
                      : const Color(0xFF4A2D8B),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _themeProvider.isDarkMode
                        ? const Color(0xFF9D84E3)
                        : const Color(0xFF4A2D8B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(
      String title, String description, String imagePath, String date) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventPage(
              title: title,
              description: description,
              imagePath: imagePath,
              date: date,
              venue: 'GIET Campus',
              time: '9:00 AM - 5:00 PM',
              organizer: 'GIET Student Council',
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(right: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  imagePath,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A2D8B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      date,
                      style: const TextStyle(
                        color: Color(0xFF4A2D8B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
