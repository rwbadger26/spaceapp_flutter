import 'package:flutter/material.dart';
import 'home_screen.dart';

/// First screen the user sees.
/// We keep it simple for now: show the logo, wait, then go to HomeScreen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Future.delayed waits without blocking the UI.
    Future.delayed(const Duration(seconds: 2), () {
      // mounted is important: the widget might have been closed
      // before the 2 seconds finish.
      if (mounted) {
        // pushReplacement removes the splash from the back stack,
        // so the user cannot swipe back to it.
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/cosmopulse.jpg',
              width: 180,
              height: 180,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            const Text(
              'CosmoPulse',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}