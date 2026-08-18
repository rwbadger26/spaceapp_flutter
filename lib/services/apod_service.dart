import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/apod.dart';
import '../utils/constants.dart';

/// Handles all NASA APOD network logic.
/// We keep this separate from the UI so HomeScreen only cares about data, not HTTP.
class ApodService {
  // Used when the API is down, the key is invalid, or the request times out.
  // The app should still show something useful instead of a blank screen.
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

  /// Returns a list of recent APOD items.
  /// This is async because a network request takes time.
  Future<List<Apod>> fetchRecentApods() async {
    try {
      final url = Uri.parse(
        '${Constants.apodBaseUrl}?api_key=${Constants.nasaApiKey}&count=20',
      );

      // Timeout is important: without it, a hanging request can leave the UI
      // on the loading spinner forever.
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        // NASA sends a JSON list. decode() turns the String into Dart objects.
        final List<dynamic> data = json.decode(response.body);

        // Convert each JSON map into our Apod model.
        return data.map((json) => Apod.fromJson(json)).toList();
      } else {
        // Server answered, but not successfully (403, 429, 500, etc.)
        return _fallbackApods;
      }
    } catch (e) {
      // Covers no internet, timeout, invalid JSON, etc.
      return _fallbackApods;
    }
  }
}