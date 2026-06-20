import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MediumWeatherApp());
}

// Data model for Open-Meteo Geocoding API results
class LocationResult {
  final String name;
  final String region;
  final String country;
  final double latitude;
  final double longitude;

  LocationResult({
    required this.name,
    required this.region,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory LocationResult.fromJson(Map<String, dynamic> json) {
    return LocationResult(
      name: json['name'] ?? '',
      region: json['admin1'] ?? '',
      country: json['country'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }
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
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    // Debounce to avoid spamming the API while typing
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final url = Uri.parse('https://geocoding-api.open-meteo.com/v1/search?name=$query&count=5&language=en&format=json');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final results = data['results'] as List<dynamic>?;
          
          if (results != null) {
            setState(() {
              _searchResults = results.map((e) => LocationResult.fromJson(e)).toList();
            });
          } else {
            setState(() {
              _searchResults.clear();
            });
          }
        }
      } catch (e) {
        // We will handle connection errors fully in ex03, but let's clear results for now
        setState(() {
          _searchResults.clear();
        });
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
      final url = Uri.parse('https://geocoding-api.open-meteo.com/v1/search?name=$query&count=1&language=en&format=json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List<dynamic>?;
        
        if (results != null && results.isNotEmpty) {
          _selectLocation(LocationResult.fromJson(results[0]));
        } else {
          setState(() {
            _errorText = "Could not find any result for the supplied address.";
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorText = "The service connection is lost, please check your internet connection.";
      });
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF455A64),
          title: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged, // Triggered on every keystroke
            onSubmitted: _onSearchSubmitted, // Triggered on Enter
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Search location...",
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
              icon: Icon(Icons.search, color: Colors.white),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.near_me, color: Colors.white),
              onPressed: _fetchLocation,
            ),
          ],
        ),
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
        bottomNavigationBar: const BottomAppBar(
          color: Color(0xFF455A64),
          padding: EdgeInsets.zero,
          child: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.wb_sunny_outlined), text: 'Currently'),
              Tab(icon: Icon(Icons.calendar_today), text: 'Today'),
              Tab(icon: Icon(Icons.date_range), text: 'Weekly'),
            ],
          ),
        ),
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
