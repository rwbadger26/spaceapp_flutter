class NewsArticle {
  final String title;
  final String summary;
  final String date;
  final String source;
  final String? imageUrl;
  final String? url;

  NewsArticle({
    required this.title,
    required this.summary,
    required this.date,
    required this.source,
    this.imageUrl,
    this.url,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    final publishedAt = json['published_at'] as String?;

    return NewsArticle(
      title: json['title'] ?? 'Untitled',
      summary: json['summary'] ?? '',
      date: (publishedAt != null && publishedAt.length >= 10)
          ? publishedAt.substring(0, 10)
          : 'TBD',
      source: json['news_site'] ?? 'Unknown',
      imageUrl: json['image_url'] as String?,
      url: json['url'] as String?,
    );
  }
}