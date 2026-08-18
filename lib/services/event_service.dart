import '../models/event.dart';

class EventService {
  // Temporary sample data.
  // Later this file will also fetch Launch Library 2 and cache it.
  List<Event> getSampleEvents() {
    return [
      Event(
        title: 'Falcon 9 • Starlink mission',
        date: '2026-08-20',
        type: 'launch',
        summary: 'A SpaceX Falcon 9 launch from Florida. Placeholder sample for the Events tab.',
        source: 'Sample data',
        agency: 'SpaceX',
        location: 'Cape Canaveral, USA',
      ),
      Event(
        title: 'JAXA H3 launch',
        date: '2026-09-05',
        type: 'launch',
        summary: 'An upcoming H3 mission. This is sample data until the live API is connected.',
        source: 'Sample data',
        agency: 'JAXA',
        location: 'Tanegashima, Japan',
      ),
      Event(
        title: 'Perseid meteor shower peak',
        date: '2026-08-12',
        type: 'sky',
        summary: 'One of the best annual meteor showers. Best viewed after midnight in a dark sky.',
        source: 'Curated sky event',
      ),
    ];
  }
}