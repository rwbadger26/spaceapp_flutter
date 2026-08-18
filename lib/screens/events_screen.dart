import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final events = EventService().getSampleEvents();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final Event event = events[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(event.title),
              subtitle: Text('${event.date}  •  ${event.type}'),
              trailing: Text(event.agency ?? ''),
            ),
          );
        },
      ),
    );
  }
}