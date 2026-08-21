import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/apod.dart';

class BookmarkService {
  static const _key = 'bookmarked_apods';

  Future<List<Apod>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List<dynamic> data = json.decode(jsonString);
    return data
        .map((item) => Apod.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<bool> isBookmarked(String date) async {
    final bookmarks = await getBookmarks();
    return bookmarks.any((apod) => apod.date == date);
  }

  Future<void> toggle(Apod apod) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();

    final exists = bookmarks.any((item) => item.date == apod.date);
    if (exists) {
      bookmarks.removeWhere((item) => item.date == apod.date);
    } else {
      bookmarks.insert(0, apod);
    }

    final jsonString =
        json.encode(bookmarks.map((item) => item.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }
}