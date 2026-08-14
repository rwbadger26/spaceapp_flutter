import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/apod.dart';
import '../utils/constants.dart';

class ApodService {
  // Fallback data used when the NASA API is unavailable
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

  Future<List<Apod>> fetchRecentApods() async {
    try {
      final url = Uri.parse(
        '${Constants.apodBaseUrl}?api_key=${Constants.nasaApiKey}&count=20',
      );

      final response = await http
          .get(url)
          .timeout(
            const Duration(seconds: 8),
          ); // ← stop waiting after 8 seconds

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Apod.fromJson(json)).toList();
      } else {
        return _fallbackApods;
      }
    } catch (e) {
      // Any error or timeout → use fallback
      return _fallbackApods;
    }
  }
}
