import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event.dart';
import '../utils/constants.dart';

class EventService {
  static const _eventsKey = 'cached_events';
  static const _fetchedAtKey = 'events_fetched_at';
  static const _cacheFor = Duration(hours: 12);

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

  Future<List<Event>> fetchEvents({bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();

    if (!forceRefresh) {
      final cached = _readCache(prefs);
      if (cached != null) return cached;
    }

    try {
      final response = await http
          .get(Uri.parse(Constants.launchLibraryUrl))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        return _readCache(prefs) ?? getSampleEvents();
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
          summary:
              map['mission']?['description'] ??
              'No mission description available.',
          source: 'Launch Library 2',
          agency: map['launch_service_provider']?['name'] as String?,
          location: map['pad']?['location']?['name'] as String?,
        );
      }).toList();

      final majorLaunches = launches.where((event) {
        final title = event.title.toLowerCase();
        return !title.contains('starlink') && !title.contains('oneweb');
      }).toList();

      final skyEvents = getSampleEvents()
          .where((event) => event.type == 'sky')
          .toList();
      final events = [...majorLaunches, ...skyEvents];

      await _saveCache(prefs, events);
      return events;
    } catch (e) {
      return _readCache(prefs) ?? getSampleEvents();
    }
  }

  List<Event>? _readCache(SharedPreferences prefs) {
    final fetchedAtMs = prefs.getInt(_fetchedAtKey);
    final jsonString = prefs.getString(_eventsKey);

    if (fetchedAtMs == null || jsonString == null) return null;

    final age = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(fetchedAtMs),
    );
    if (age > _cacheFor) return null;

    final List<dynamic> data = json.decode(jsonString);
    return data
        .map((item) => Event.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveCache(SharedPreferences prefs, List<Event> events) async {
    final jsonString = json.encode(events.map((e) => e.toJson()).toList());
    await prefs.setString(_eventsKey, jsonString);
    await prefs.setInt(_fetchedAtKey, DateTime.now().millisecondsSinceEpoch);
  }
}
