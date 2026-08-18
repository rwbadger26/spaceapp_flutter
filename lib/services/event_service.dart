import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import '../utils/constants.dart';

class EventService {
  List<Event> getSampleEvents() {
    return [
      Event(
        title: 'Falcon 9 • Starlink mission',
        date: '2026-08-20',
        type: 'launch',
        summary:
            'A SpaceX Falcon 9 launch from Florida. Placeholder sample for the Events tab.',
        source: 'Sample data',
        agency: 'SpaceX',
        location: 'Cape Canaveral, USA',
      ),
      Event(
        title: 'JAXA H3 launch',
        date: '2026-09-05',
        type: 'launch',
        summary:
            'An upcoming H3 mission. This is sample data until the live API is connected.',
        source: 'Sample data',
        agency: 'JAXA',
        location: 'Tanegashima, Japan',
      ),
      Event(
        title: 'Perseid meteor shower peak',
        date: '2026-08-12',
        type: 'sky',
        summary:
            'One of the best annual meteor showers. Best viewed after midnight in a dark sky.',
        source: 'Curated sky event',
      ),
    ];
  }

  Future<List<Event>> fetchEvents() async {
    try {
      final response = await http
          .get(Uri.parse(Constants.launchLibraryUrl))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        return getSampleEvents();
      }

      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'] ?? [];

      final launches = results.map((item) {
        final map = item as Map<String, dynamic>;
        final net = map['net'] as String?;
        final date = (net != null && net.length >= 10)
            ? net.substring(0, 10)
            : 'TBD';

        return Event(
          title: map['name'] ?? 'Upcoming launch',
          date: date,
          type: 'launch',
          summary: map['mission']?['description'] ??
              'No mission description available.',
          source: 'Launch Library 2',
          agency: map['launch_service_provider']?['name'] as String?,
          location: map['pad']?['location']?['name'] as String?,
        );
      }).toList();

      // Keep the curated sky event at the end for now
      final skyEvents =
          getSampleEvents().where((event) => event.type == 'sky').toList();

      return [...launches, ...skyEvents];
    } catch (e) {
      print('Launch API failed: $e');
      return getSampleEvents();
    }
  }
}