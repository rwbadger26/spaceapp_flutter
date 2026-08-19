import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/apod.dart';
import '../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApodService {
  static const _apodsKey = 'cached_apods';
  static const _fetchedAtKey = 'apods_fetched_at';
  static const _cacheFor = Duration(hours: 12);
  static final List<Apod> _fallbackApods = [
    Apod(
      title: 'The Pillars of Creation',
      explanation:
          'This iconic image from the Hubble Space Telescope shows towering pillars of gas and dust in the Eagle Nebula, where new stars are being born. Captured in 1995, it remains one of the most famous astronomical photographs ever taken.',
      date: '1995-04-01',
      url: null,
      hdurl: null,
      mediaType: 'image',
    ),
    Apod(
      title: 'Earthrise',
      explanation:
          'Taken by astronaut William Anders during the Apollo 8 mission in 1968, this photograph of Earth rising over the lunar horizon became a powerful symbol of our planet’s fragility and unity.',
      date: '1968-12-24',
      url: null,
      hdurl: null,
      mediaType: 'image',
    ),
    Apod(
      title: 'A Cosmic Ballet',
      explanation:
          'When the NASA API is offline, CosmoPulse still shows you beautiful space stories. This is a placeholder entry so the app never feels empty.',
      date: '2024-01-01',
      url: null,
      hdurl: null,
      mediaType: 'image',
    ),
  ];

  String _ymd(DateTime date) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${date.year}-${two(date.month)}-${two(date.day)}';
  }

  Future<List<Apod>> fetchRecentApods({bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();

    if (!forceRefresh) {
      final cached = _readCache(prefs);
      if (cached != null) return cached;
    }

    try {
      final end = DateTime.now().toUtc();
      final start = end.subtract(const Duration(days: 19));

      final url = Uri.parse(
        '${Constants.apodBaseUrl}?api_key=${Constants.nasaApiKey}'
        '&start_date=${_ymd(start)}&end_date=${_ymd(end)}',
      );

      final response = await http.get(url).timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        return _readCache(prefs) ?? _fallbackApods;
      }

      final List<dynamic> data = json.decode(response.body);
      final apods = data.map((json) => Apod.fromJson(json)).toList();
      final latestFirst = apods.reversed.toList();

      await _saveCache(prefs, latestFirst);
      return latestFirst;
    } catch (e) {
      return _readCache(prefs) ?? _fallbackApods;
    }
  }

  List<Apod>? _readCache(SharedPreferences prefs) {
    final fetchedAtMs = prefs.getInt(_fetchedAtKey);
    final jsonString = prefs.getString(_apodsKey);
    if (fetchedAtMs == null || jsonString == null) return null;

    final age = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(fetchedAtMs),
    );
    if (age > _cacheFor) return null;

    final List<dynamic> data = json.decode(jsonString);
    return data
        .map((item) => Apod.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveCache(SharedPreferences prefs, List<Apod> apods) async {
    final jsonString = json.encode(apods.map((apod) => apod.toJson()).toList());
    await prefs.setString(_apodsKey, jsonString);
    await prefs.setInt(_fetchedAtKey, DateTime.now().millisecondsSinceEpoch);
  }
}
