import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'user_login_page.dart';
import 'reset_password_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _feedbackController = TextEditingController();
  String? _profileImageUrl;
  File? _imageFile;
  double _rating = 0;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _uploadImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
        // TODO: Implement actual image upload to server
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully!'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to pick image')));
    }
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: const Color(0xFF4A2D8B),
            size: 32,
          ),
          onPressed: () {
            setState(() {
              _rating = index + 1;
            });
          },
        );
      }),
    );
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
          'Profile',
          style: TextStyle(
            color: Color(0xFF4A2D8B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Image Section
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (_profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!) as ImageProvider
                            : null),
                    child: _imageFile == null && _profileImageUrl == null
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Color(0xFF4A2D8B),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFF4A2D8B),
                      radius: 18,
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                        onPressed: _uploadImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // User Details Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Name', 'vinay kumar'),
                  const Divider(),
                  _buildInfoRow('Roll No', '23T95A0515'),
                  const Divider(),
                  _buildInfoRow('Email', 'vinaykumarmvk17@gmail.com'),
                  const Divider(),
                  _buildInfoRow('Branch', 'Computer Science'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Feedback Form with Star Rating
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Feedback',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A2D8B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Rate your experience',
                    style: TextStyle(fontSize: 16, color: Color(0xFF4A2D8B)),
                  ),
                  const SizedBox(height: 8),
                  _buildRatingStars(),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _feedbackController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Write your feedback here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_rating > 0 &&
                            _feedbackController.text.isNotEmpty) {
                          // TODO: Submit feedback with rating
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Feedback submitted successfully!'),
                            ),
                          );
                          _feedbackController.clear();
                          setState(() {
                            _rating = 0;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please provide both rating and feedback',
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A2D8B),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Submit Feedback',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResetPasswordPage(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.lock_reset,
                      color: Color(0xFF4A2D8B),
                    ),
                    label: const Text(
                      'Reset Password',
                      style: TextStyle(color: Color(0xFF4A2D8B)),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFF4A2D8B)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const UserLoginPage(),
                        ),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF4A2D8B),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
