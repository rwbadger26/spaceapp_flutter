import 'package:flutter/material.dart';
import '../models/apod.dart';
import '../services/bookmark_service.dart';
import '../widgets/apod_card.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  final BookmarkService _bookmarks = BookmarkService();
  List<Apod> _saved = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final saved = await _bookmarks.getBookmarks();
    setState(() {
      _saved = saved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved'),
      ),
      body: _saved.isEmpty
          ? const Center(
              child: Text(
                'No saved pictures yet',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: _saved.length,
              itemBuilder: (context, index) {
                return ApodCard(apod: _saved[index]);
              },
            ),
    );
  }
}