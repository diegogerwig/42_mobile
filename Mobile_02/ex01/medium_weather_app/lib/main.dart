import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'theme/app_theme.dart';
import 'widgets/main_weather_layout.dart';
import 'services/geolocation_service.dart';
import 'services/weather_api.dart';

import 'models/location_result.dart';


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
      theme: AppTheme.theme,
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _searchText = "";
  String _errorText = "";
  
  final TextEditingController _searchController = TextEditingController();
  
  // List to hold the autocomplete suggestions
  List<LocationResult> _searchResults = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  // GEOLOCATION LOGIC (From Ex00)
  Future<void> _fetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    setState(() {
      _errorText = "";
      _searchResults.clear();
      _searchController.clear();
    });

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _errorText = "Geolocation is not available, please enable it in your App settings";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _errorText = "Geolocation is not available, please enable it in your App settings";
        });
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _errorText = "Geolocation is not available, please enable it in your App settings";
      });
      return;
    } 

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.low)
      );
      setState(() {
        _searchText = "${position.latitude} ${position.longitude}";
      });
    } catch (e) {
      setState(() {
        _errorText = "Geolocation is not available, please enable it in your App settings";
      });
    }
  }

  // GEOCODING API LOGIC (Ex01)
    void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (query.isEmpty) {
      setState(() { _searchResults.clear(); });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final results = await WeatherApi.fetchLocations(query, count: 5);
        if (mounted) {
          setState(() { _searchResults = results; });
        }
      } catch (e) {
        if (mounted) {
          setState(() { _searchResults.clear(); });
        }
      }
    });
  }

  // If user hits "Enter" without selecting from the list
    Future<void> _onSearchSubmitted(String query) async {
    if (query.isEmpty) return;
    
    setState(() {
      _searchResults.clear();
      _errorText = "";
    });
    
    try {
      final results = await WeatherApi.fetchLocations(query, count: 1);
      if (results.isNotEmpty) {
        _selectLocation(results.first);
      } else {
        setState(() { _errorText = "Could not find any result for the supplied address."; });
      }
    } catch (e) {
      setState(() { _errorText = e.toString(); });
    }
  }

  // When user taps a suggestion from the list
  void _selectLocation(LocationResult result) {
    setState(() {
      _searchController.text = result.name;
      _searchResults.clear();
      // Temporarily displaying coordinates to prove we got the correct city.
      // In Ex02 we will use these to fetch the weather.
      _searchText = "${result.latitude} ${result.longitude}";
      _errorText = "";
    });
    FocusScope.of(context).unfocus(); // Close the keyboard
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainWeatherLayout(
      searchController: _searchController,
      onSearchChanged: _onSearchChanged,
      onSearchSubmitted: _onSearchSubmitted,
      onGeolocationPressed: _fetchLocation,
      body: Stack(
        children: [
          // Underlying Tabs
          TabBarView(
            children: [
              _buildTabContent("Currently"),
              _buildTabContent("Today"),
              _buildTabContent("Weekly"),
            ],
          ),
          
          // Autocomplete Suggestions Overlay
          if (_searchResults.isNotEmpty)
            Material(
              color: Colors.white,
              elevation: 4.0,
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
                  // Formatting subtitle: "Region, Country" or just "Country" if region is empty
                  final subtitle = result.region.isNotEmpty 
                      ? '${result.region}, ${result.country}' 
                      : result.country;
                      
                  return ListTile(
                    leading: const Icon(Icons.location_city),
                    title: Text(result.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(subtitle),
                    onTap: () => _selectLocation(result),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabContent(String tabName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_errorText.isEmpty) 
            Text(
              tabName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          if (_errorText.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                _errorText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            ),
          ] else if (_searchText.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              _searchText,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ]
        ],
      ),
    );
  }
}
