import 'package:flutter/material.dart';
import 'package:gietsmart/home_page.dart';
import 'package:gietsmart/pages/notification_page.dart';
import 'package:gietsmart/profile_page.dart';
import 'package:gietsmart/pages/downloads_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:gietsmart/student_id_upload_page.dart';
import 'package:gietsmart/admin_login_page.dart';
import 'package:gietsmart/pages/virtual_id_card_page.dart';
import 'package:gietsmart/pages/payment_page.dart';

class StudentIdRegistrationPage extends StatefulWidget {
  const StudentIdRegistrationPage({super.key});

  @override
  State<StudentIdRegistrationPage> createState() =>
      _StudentIdRegistrationPageState();
}

class _StudentIdRegistrationPageState extends State<StudentIdRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _rollNumberController = TextEditingController();
  final _branchController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedReason;
  String? _selectedYear;
  int _selectedIndex = 0;
  bool _isNewRegistration = false;
  File? _selectedFile;
  String? _selectedFileName;
  bool _isUploading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _rollNumberController.dispose();
    _branchController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() => _selectedIndex = index);

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NotificationPage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
        break;
    }
  }

  Future<void> _downloadFile() async {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A2D8B)),
          ),
        );
      },
    );

    try {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File downloaded successfully!'),
            backgroundColor: Color(0xFF4A2D8B),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DownloadsPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error downloading file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
          _selectedFileName = result.files.single.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a file first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUploading = true);

    try {
      String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${_selectedFileName}';
      final storageRef =
          FirebaseStorage.instance.ref().child('student_ids/$fileName');
      await storageRef.putFile(_selectedFile!);
      final downloadUrl = await storageRef.getDownloadURL();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File uploaded successfully!'),
            backgroundColor: Color(0xFF4A2D8B),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StudentIdUploadPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F0F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A2D8B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Student ID Registration',
          style: TextStyle(
            color: Color(0xFF4A2D8B),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Color(0xFF4A2D8B)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Help'),
                  content: const Text(
                    'For new registrations, click "New" and login as admin. '
                    'For existing students, fill in the form and download your ID card.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _isNewRegistration = false);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _isNewRegistration
                                    ? Colors.transparent
                                    : const Color(0xFF4A2D8B),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Old',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _isNewRegistration
                                      ? const Color(0xFF4A2D8B)
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AdminLoginPage(
                                      sourcePage: 'student_id'),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _isNewRegistration
                                    ? const Color(0xFF4A2D8B)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'New',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _isNewRegistration
                                      ? Colors.white
                                      : const Color(0xFF4A2D8B),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isNewRegistration
                        ? _buildNewRegistrationForm()
                        : _buildOldRegistrationForm(),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 100,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'downloadButton',
                  onPressed: _downloadFile,
                  backgroundColor: const Color(0xFF4A2D8B),
                  child: const Icon(Icons.download, color: Colors.white),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  heroTag: 'virtualIdButton',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VirtualIdCardPage(),
                      ),
                    );
                  },
                  backgroundColor: const Color(0xFF4A2D8B),
                  child: const Icon(Icons.credit_card, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF4A2D8B),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.download), label: 'Downloads'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'Notifications'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildOldRegistrationForm() {
    return Column(
      key: const ValueKey('old'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Student Details',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4A2D8B),
                    ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                hint: 'Enter your full name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _rollNumberController,
                label: 'Roll Number',
                hint: 'Enter your roll number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your roll number';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                hint: 'Enter your phone number',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'Enter your email address',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _branchController,
                label: 'Branch',
                hint: 'Enter your branch',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your branch';
                  }
                  return null;
                },
              ),
              _buildDropdownField(
                label: 'Reason to Lost Id Card',
                value: _selectedReason,
                items: ['Lost', 'Damaged', 'Other'],
                onChanged: (value) {
                  setState(() => _selectedReason = value);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(
                    studentName: _nameController.text,
                    rollNumber: _rollNumberController.text,
                    amount: '500', // Fixed amount for ID card
                  ),
                ),
              );
            },
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A2D8B),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewRegistrationForm() {
    return Column(
      key: const ValueKey('new'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Student Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2D8B),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _rollNumberController,
                label: 'Student Registration Id',
                hint: 'Enter your student registration ID',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your student registration ID';
                  }
                  return null;
                },
              ),
              _buildDropdownField(
                label: 'Year of Studying',
                value: _selectedYear,
                items: ['1st Year', '2nd Year', '3rd Year', '4th Year'],
                onChanged: (value) {
                  setState(() => _selectedYear = value);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Upload file as PDF or JPG',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              if (_selectedFileName != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A2D8B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.attach_file, color: Color(0xFF4A2D8B)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selectedFileName!,
                          style: const TextStyle(
                            color: Color(0xFF4A2D8B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isUploading ? null : _pickFile,
                      icon: const Icon(Icons.attach_file),
                      label: const Text('Select File'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF4A2D8B),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFF4A2D8B)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (_selectedFile != null)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isUploading ? null : _uploadFile,
                        icon: _isUploading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Icon(Icons.upload_file),
                        label: Text(_isUploading ? 'Uploading...' : 'Upload'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A2D8B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    int? maxLines,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines ?? 1,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select ${label.toLowerCase()}';
          }
          return null;
        },
      ),
    );
  }
}
