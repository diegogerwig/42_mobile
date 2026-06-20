import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location_result.dart';
import '../models/weather_data.dart';

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

  static Future<WeatherData> fetchWeather(double latitude, double longitude) async {
    try {
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude'
        '&current=temperature_2m,weather_code,wind_speed_10m'
        '&hourly=temperature_2m,weather_code,wind_speed_10m'
        '&daily=weather_code,temperature_2m_max,temperature_2m_min'
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return WeatherData.fromJson(jsonDecode(response.body));
      }
      throw WeatherApiException("The service connection is lost, please check your internet connection or try again later");
    } catch (e) {
      throw WeatherApiException("The service connection is lost, please check your internet connection or try again later");
    }
  }
}
