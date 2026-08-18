import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Events coming soon',
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      ),
    );
  }
}