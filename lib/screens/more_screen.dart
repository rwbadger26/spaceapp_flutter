import 'package:flutter/material.dart';
import '../models/news_article.dart';
import '../services/news_service.dart';
import '../widgets/news_card.dart';
import '../widgets/loading_error_widgets.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final NewsService _newsService = NewsService();
  List<NewsArticle> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles({bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
    });

    final articles = await _newsService.fetchArticles(
      forceRefresh: forceRefresh,
    );

    setState(() {
      _articles = articles;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News'),),
      body: _isLoading
          ? const LoadingWidget()
          : RefreshIndicator(
              onRefresh: () => _loadArticles(forceRefresh: true),
              color: const Color(0xFF64B5F6),
              child: ListView.builder(
                itemCount: _articles.length,
                itemBuilder: (context, index) {
                  return NewsCard(article: _articles[index]);
                },
              ),
            ),
    );
  }
}
