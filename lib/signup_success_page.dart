import 'package:flutter/material.dart';
import 'home_page.dart';

class SignupSuccessPage extends StatelessWidget {
  const SignupSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Color(0xFF4A2D8B),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Sign up was successful',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        const MyHomePage(title: 'Student Dashboard'),
                  ),
                );
              },
              child: const Text('Continue to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
