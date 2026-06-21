import 'package:flutter/material.dart';
import 'screens/weather_screen.dart';

void main() {
  runApp(const AdvancedWeatherApp());
}

class AdvancedWeatherApp extends StatelessWidget {
  const AdvancedWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const WeatherScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
