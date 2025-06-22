import 'package:flutter/material.dart';

class EventPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final String date;
  final String venue;
  final String time;
  final String organizer;

  const EventPage({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.date,
    required this.venue,
    required this.time,
    required this.organizer,
  });

  void _showRegistrationSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully registered for the event!'),
        backgroundColor: Color(0xFF4A2D8B),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A2D8B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF4A2D8B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
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
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A2D8B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'About Event',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A2D8B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Event Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A2D8B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(Icons.calendar_today, 'Date', date),
                  _buildDetailRow(Icons.access_time, 'Time', time),
                  _buildDetailRow(Icons.location_on, 'Venue', venue),
                  _buildDetailRow(Icons.person, 'Organizer', organizer),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showRegistrationSuccess(context),
                      icon: const Icon(Icons.event_available),
                      label: const Text('Register for Event'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A2D8B),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4A2D8B)),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A2D8B),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
