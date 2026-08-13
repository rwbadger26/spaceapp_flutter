import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/apod.dart';
import '../utils/constants.dart';

class ApodService {
  // Fetches the last 20 APOD entries
  Future<List<Apod>> fetchRecentApods() async {
    final url = Uri.parse(
      '${Constants.apodBaseUrl}?api_key=${Constants.nasaApiKey}&count=20',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Apod.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load APODs: ${response.statusCode}');
    }
  }
}