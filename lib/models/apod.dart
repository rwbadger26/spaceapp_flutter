class Apod {
  final String title;
  final String explanation;
  final String date;
  final String? url; // image or video url
  final String? hdurl; // high-res image (sometimes null)
  final String mediaType; // "image" or "video"

  Apod({
    required this.title,
    required this.explanation,
    required this.date,
    this.url,
    this.hdurl,
    required this.mediaType,
  });

  // Convert JSON from NASA API into an Apod object
  factory Apod.fromJson(Map<String, dynamic> json) {
    return Apod(
      title: json['title'] ?? 'No title',
      explanation: json['explanation'] ?? 'No explanation',
      date: json['date'] ?? '',
      url: json['url'],
      hdurl: json['hdurl'],
      mediaType: json['media_type'] ?? 'image',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'explanation': explanation,
      'date': date,
      'url': url,
      'hdurl': hdurl,
      'media_type': mediaType,
    };
  }
}
