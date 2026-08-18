import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';
import '../widgets/event_card.dart';
import '../widgets/loading_error_widgets.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final EventService _eventService = EventService();
  List<Event> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
    });

    final events = await _eventService.fetchEvents();

    setState(() {
      _events = events;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: _isLoading
          ? const LoadingWidget()
          : RefreshIndicator(
              onRefresh: _loadEvents,
              color: const Color(0xFF64B5F6),
              child: ListView.builder(
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  return EventCard(event: _events[index]);
                },
              ),
            ),
    );
  }
}