import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gietsmart/home_page.dart';
import 'package:gietsmart/pages/notification_page.dart';
import 'package:gietsmart/profile_page.dart';
import 'pages/downloads_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class ProjectUploadPage extends StatefulWidget {
  const ProjectUploadPage({super.key});

  @override
  State<ProjectUploadPage> createState() => _ProjectUploadPageState();
}

class _ProjectUploadPageState extends State<ProjectUploadPage> {
  final List<ProjectFile> _projectFiles = [];
  final _formKey = GlobalKey<FormState>();
  final _projectNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _selectedIndex = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

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

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'zip'],
      );

      if (result != null) {
        _showAddProjectDialog(result.files.first);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick file')),
      );
    }
  }

  Future<void> _uploadFileToFirebase(
      PlatformFile file, ProjectFile projectFile) async {
    try {
      if (_auth.currentUser == null) {
        throw Exception("User not logged in");
      }
      final user = _auth.currentUser!;
      if (file.path == null) {
        throw Exception("File path is null");
      }
      final ref = _storage.ref().child('projects/${user.uid}/${file.name}');
      final uploadTask = ref.putFile(File(file.path!));
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await _firestore.collection('projects').add({
        'userId': user.uid,
        'projectName': projectFile.name,
        'description': projectFile.description,
        'fileName': projectFile.fileName,
        'fileSize': projectFile.fileSize,
        'dateTime': projectFile.dateTime,
        'downloadUrl': downloadUrl,
      });

      setState(() {
        _projectFiles.add(projectFile);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Project file added successfully!'),
          backgroundColor: Color(0xFF4A2D8B),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload file: $e')),
      );
    }
  }

  void _showAddProjectDialog(PlatformFile file) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Project Details',
            style: TextStyle(color: Color(0xFF4A2D8B)),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _projectNameController,
                  decoration: const InputDecoration(
                    labelText: 'Project Name',
                    labelStyle: TextStyle(color: Color(0xFF4A2D8B)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter project name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Color(0xFF4A2D8B)),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _projectNameController.clear();
                _descriptionController.clear();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final projectFile = ProjectFile(
                    name: _projectNameController.text,
                    description: _descriptionController.text,
                    fileName: file.name,
                    fileSize: file.size,
                    dateTime: DateTime.now(),
                  );
                  _uploadFileToFirebase(file, projectFile);
                  Navigator.pop(context);
                  _projectNameController.clear();
                  _descriptionController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A2D8B),
              ),
              child: const Text('Add Project'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F0F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Project Files',
          style: TextStyle(
            color: Color(0xFF4A2D8B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _projectFiles.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.upload_file,
                    size: 64,
                    color: const Color(0xFFFFFFFF),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No project files yet',
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
              itemCount: _projectFiles.length,
              itemBuilder: (context, index) {
                final project = _projectFiles[index];
                return Card(
                  margin:
                      const EdgeInsets.only(bottom: 12), // Corrected to bottom
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.file_present,
                      color: Color(0xFF4A2D8B),
                    ),
                    title: Text(project.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(project.description),
                        Text(
                          'File: ${project.fileName} (${(project.fileSize / 1024).toStringAsFixed(2)} KB)',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        Text(
                          'Uploaded on ${project.formattedDate}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickFile, // Corrected from onPressed_pickFile
        backgroundColor: const Color(0xFF4A2D8B),
        child: const Icon(Icons.add, color: Colors.white),
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

  @override
  void dispose() {
    _projectNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

class ProjectFile {
  final String name;
  final String description;
  final String fileName;
  final int fileSize;
  final DateTime dateTime;

  ProjectFile({
    required this.name,
    required this.description,
    required this.fileName,
    required this.fileSize,
    required this.dateTime,
  });

  String get formattedDate {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
