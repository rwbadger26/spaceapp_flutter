class Event {
  final String title;
  final String date;          // keep as String for now, same as Apod
  final String type;          // "launch" or "sky"
  final String summary;
  final String source;
  final String? agency;       // SpaceX, NASA, JAXA...
  final String? location;

  Event({
    required this.title,
    required this.date,
    required this.type,
    required this.summary,
    required this.source,
    this.agency,
    this.location,
  });

  // Used later when we read cached JSON or API JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'] as String,
      date: json['date'] as String,
      type: json['type'] as String,
      summary: json['summary'] as String,
      source: json['source'] as String,
      agency: json['agency'] as String?,
      location: json['location'] as String?,
    );
  }

  // Used when we save the list to local JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'type': type,
      'summary': summary,
      'source': source,
      'agency': agency,
      'location': location,
    };
  }
}