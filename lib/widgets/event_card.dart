import 'package:flutter/material.dart';
import '../models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final isLaunch = event.type == 'launch';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isLaunch
                        ? const Color(0xFF64B5F6).withOpacity(0.2)
                        : const Color(0xFF81C784).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isLaunch ? 'Launch' : 'Sky event',
                    style: TextStyle(
                      fontSize: 12,
                      color: isLaunch
                          ? const Color(0xFF64B5F6)
                          : const Color(0xFF81C784),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  event.date,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            if (event.agency != null || event.location != null) ...[
              const SizedBox(height: 6),
              Text(
                [event.agency, event.location].whereType<String>().join(' • '),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
            const SizedBox(height: 10),
            Text(
              event.summary,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Source: ${event.source}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}