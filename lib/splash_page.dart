import 'package:flutter/material.dart';
import 'package:sabay_list_itc/screens/auth/signup_page.dart';
import 'screens/auth/login_page.dart' hide SignupPage;
import 'screens/auth/signup_page.dart' hide SignupPage;

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFC1D2), // Light pink
              Color(0xFFFFEBF0), // Lighter pink
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Clock Icon on the upper right
            Positioned(
              right: -50,
              top: 100,
              child: Image.asset(
                'assets/clock.png',
                width: 225.56,
                height: 225.56,
                fit: BoxFit.contain,
              ),
            ),
            // Centered Column for Text and Button
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // TODO APP Text
                  const Text(
                    'TODO APP',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(
                          Icons.circle,
                          size: 8,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Get Started Button - Goes to LoginPage
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[200],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            // Calendar Icon at the bottom left
            Positioned(
              left: -60,
              bottom: 100,
              child: Image.asset(
                'assets/calendar.png',
                width: 225.56,
                height: 225.56,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
