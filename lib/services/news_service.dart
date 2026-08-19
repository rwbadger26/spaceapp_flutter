import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_article.dart';
import '../utils/constants.dart';

class NewsService {
  static const _articlesKey = 'cached_articles';
  static const _fetchedAtKey = 'articles_fetched_at';
  static const _cacheFor = Duration(hours: 12);

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

  Future<List<NewsArticle>> fetchArticles({bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();

    if (!forceRefresh) {
      final cached = _readCache(prefs);
      if (cached != null) return cached;
    }

    try {
      final response = await http
          .get(Uri.parse(Constants.spaceNewsUrl))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        return _readCache(prefs) ?? getSampleArticles();
      }

      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'] ?? [];
      final articles = results
          .map((item) => NewsArticle.fromJson(item as Map<String, dynamic>))
          .toList();

      await _saveCache(prefs, articles);
      return articles;
    } catch (e) {
      return _readCache(prefs) ?? getSampleArticles();
    }
  }

  List<NewsArticle>? _readCache(SharedPreferences prefs) {
    final fetchedAtMs = prefs.getInt(_fetchedAtKey);
    final jsonString = prefs.getString(_articlesKey);
    if (fetchedAtMs == null || jsonString == null) return null;

    final age = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(fetchedAtMs),
    );
    if (age > _cacheFor) return null;

    final List<dynamic> data = json.decode(jsonString);
    return data
        .map((item) => NewsArticle.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveCache(
    SharedPreferences prefs,
    List<NewsArticle> articles,
  ) async {
    final jsonString =
        json.encode(articles.map((article) => article.toJson()).toList());
    await prefs.setString(_articlesKey, jsonString);
    await prefs.setInt(_fetchedAtKey, DateTime.now().millisecondsSinceEpoch);
  }
}