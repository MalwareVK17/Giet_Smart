import 'package:flutter/material.dart';
import 'package:gietsmart/home_page.dart';
import 'package:gietsmart/pages/notification_page.dart';
import 'package:gietsmart/profile_page.dart';
import 'pages/downloads_page.dart';

//main class StudentCertificatesBookingPage
class StudentCertificatesBookingPage extends StatefulWidget {
  const StudentCertificatesBookingPage({super.key});

  @override
  State<StudentCertificatesBookingPage> createState() =>
      _StudentCertificatesBookingPageState();
}

// ignore: must_be_immutable
class _StudentCertificatesBookingPageState
    extends State<StudentCertificatesBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _rollNoController = TextEditingController();
  // ignore: unused_field
  final _yearController = TextEditingController();
  String _selectedCertificateType = 'Bonafide Certificate';
  // ignore: prefer_final_fields
  int _selectedIndex = 0;

  final List<String> _certificateTypes = [
    'Bonafide Certificate',
    'Character Certificate',
    'Transfer Certificate',
    'Study Certificate',
    'Professional Certificate',
  ];
  // ignore: unused_field
  String _selectedInsituteType = 'Choose';

  final List<String> _insituteTypes = [
    'Choose',
    'GGU',
    'GIET(A)-55',
    'GIET Engg. College(T9)',
    'GIET School of Pharmacy',
    'GIET Degree college',
    'GIET Polytechnic'
  ];

  String _selectedBranchType = 'Choose';

  final List<String> _branchTypes = [
    'Choose',
    'CSE',
    'ECE',
    'IT',
    'CIVIL',
    'MECH',
    'MINING',
    'PETROLEUM',
    'EEE',
    'CSE-AIML',
    'CSE-CS',
    'CSE-DS',
    'MCA',
    'MBA',
    'GCD',
    'GIET POLYTECHNIC',
  ];
  String _selectedYearType = 'Choose';

  final List<String> _yearTypes = [
    'Choose',
    'I Year',
    'II Year',
    'III Year',
    'IV Year',
  ];

//_bookSlot method
  void _bookSlot() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Slot booked successfully!'),
          backgroundColor: Color(0xFF4A2D8B),
        ),
      );
      Navigator.pop(context);
    }
  }

//onItemTapped method
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

//build method
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
          'Certificate Booking',
          style: TextStyle(
            color: Color(0xFF4A2D8B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Student Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2D8B),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon:
                      const Icon(Icons.person, color: Color(0xFF4A2D8B)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _rollNoController,
                decoration: InputDecoration(
                  labelText: 'Roll Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon:
                      const Icon(Icons.numbers, color: Color(0xFF4A2D8B)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your roll number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedBranchType,
                decoration: InputDecoration(
                  labelText: 'Branch/Course',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon:
                      const Icon(Icons.description, color: Color(0xFF4A2D8B)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Choose';
                  }
                  return null;
                },
                items: _branchTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedBranchType = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedYearType,
                decoration: InputDecoration(
                  labelText: 'Year of Study',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon:
                      const Icon(Icons.description, color: Color(0xFF4A2D8B)),
                ),
                items: _yearTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedYearType = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedInsituteType,
                decoration: InputDecoration(
                  labelText: 'Insitute',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon:
                      const Icon(Icons.description, color: Color(0xFF4A2D8B)),
                ),
                items: _insituteTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedInsituteType = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCertificateType,
                decoration: InputDecoration(
                  labelText: 'Certificate Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon:
                      const Icon(Icons.description, color: Color(0xFF4A2D8B)),
                ),
                items: _certificateTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCertificateType = newValue;
                    });
                  }
                },
              ),

              //Button for booking slot
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _bookSlot,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A2D8B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Book Slot',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      //bottom navigation bar
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

//dispose method
  @override
  void dispose() {
    _nameController.dispose();
    _rollNoController.dispose();
    super.dispose();
  }
}
