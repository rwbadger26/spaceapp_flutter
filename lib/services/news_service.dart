import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_article.dart';
import '../utils/constants.dart';

class NewsService {
  List<NewsArticle> getSampleArticles() {
    return [
      NewsArticle(
        title: 'Sample space headline',
        summary:
            'This is fallback news for when the Spaceflight News API is unavailable.',
        date: '2026-08-19',
        source: 'Sample',
      ),
    ];
  }

  Future<List<NewsArticle>> fetchArticles() async {
    try {
      final response = await http
          .get(Uri.parse(Constants.spaceNewsUrl))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        return getSampleArticles();
      }

      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'] ?? [];

      return results
          .map((item) => NewsArticle.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return getSampleArticles();
    }
  }
}