import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location_result.dart';

class WeatherApiException implements Exception {
  final String message;
  WeatherApiException(this.message);
  @override
  String toString() => message;
}

class WeatherApi {
  static Future<List<LocationResult>> fetchLocations(String query, {int count = 5}) async {
    try {
      final url = Uri.parse('https://geocoding-api.open-meteo.com/v1/search?name=$query&count=$count&language=en&format=json');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List<dynamic>?;
        if (results != null && results.isNotEmpty) {
          return results.map((e) => LocationResult.fromJson(e)).toList();
        }
        return [];
      }
      throw WeatherApiException("The service connection is lost, please check your internet connection or try again later");
    } catch (e) {
      throw WeatherApiException("The service connection is lost, please check your internet connection or try again later");
    }
  }
}
