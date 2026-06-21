import 'package:flutter/material.dart';
import 'screens/weather_screen.dart';

void main() {
  runApp(const MediumWeatherApp());
}

class MediumWeatherApp extends StatelessWidget {
  const MediumWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medium Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: const WeatherScreen(),
    );
  }
}