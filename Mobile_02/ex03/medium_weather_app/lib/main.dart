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
import 'models/weather_data.dart';


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
  String _errorText = "";
  final TextEditingController _searchController = TextEditingController();
  
  List<LocationResult> _searchResults = [];
  Timer? _debounce;

  // The final active states for the interface
  LocationResult? _selectedLocation;
  WeatherData? _weatherData;

  @override
  void initState() {
    super.initState();
    _fetchLocationAndWeather(); // Load GPS location on startup
  }

  // 1. GPS LOGIC
    Future<void> _fetchLocationAndWeather() async {
    setState(() {
      _errorText = "";
      _searchResults.clear();
      _searchController.clear();
      _weatherData = null;
      _selectedLocation = null;
    });

    try {
      final position = await GeolocationService.getCurrentLocation();
      final loc = LocationResult(
        name: "My Location",
        region: "Current GPS",
        country: "",
        latitude: position.latitude,
        longitude: position.longitude,
      );
      _selectLocation(loc);
    } catch (e) {
      setState(() { _errorText = e.toString(); });
    }
  }

  // 2. WEATHER FETCHING LOGIC
    Future<void> _fetchWeather(LocationResult location) async {
    try {
      final data = await WeatherApi.fetchWeather(location.latitude, location.longitude);
      setState(() {
        _weatherData = data;
      });
    } catch (e) {
      setState(() { _errorText = e.toString(); });
    }
  }

  // 3. AUTOCOMPLETE SEARCH LOGIC
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

  // Fallback for forcing a search query without clicking the list
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
        setState(() { _errorText = "Could not find any result for the supplied address or coordinates."; });
      }
    } catch (e) {
      setState(() { _errorText = e.toString(); });
    }
  }

  // Triggered when clicking a city in the autocomplete
  void _selectLocation(LocationResult result) {
    setState(() {
      // Clear keyboard and reset lists
      _searchController.text = result.name == "My Location" ? "" : result.name;
      _searchResults.clear();
      _selectedLocation = result;
      _weatherData = null; // Loading state
      _errorText = "";
    });
    FocusScope.of(context).unfocus();
    _fetchWeather(result);
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
      onGeolocationPressed: _fetchLocationAndWeather,
      body: Stack(
        children: [
          TabBarView(
            children: [
              _buildCurrentTab(),
              _buildTodayTab(),
              _buildWeeklyTab(),
            ],
          ),
          
          if (_searchResults.isNotEmpty)
            Material(
              color: Colors.white,
              elevation: 4.0,
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
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
  
  // SHARED: The Location text block displayed at the top of every tab
  Widget _buildLocationHeader() {
    if (_selectedLocation == null) return const SizedBox.shrink();
    
    String sub = _selectedLocation!.region.isNotEmpty 
      ? "${_selectedLocation!.region}, ${_selectedLocation!.country}" 
      : _selectedLocation!.country;
      
    if (sub.startsWith(", ")) sub = sub.substring(2);

    return Column(
      children: [
        Text(
          _selectedLocation!.name,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        if (sub.isNotEmpty)
          Text(
            sub,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  // TAB 1: Currently
  Widget _buildCurrentTab() {
    if (_errorText.isNotEmpty) {
      return Center(child: Padding(padding: const EdgeInsets.all(20), child: Text(_errorText, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center)));
    }
    if (_weatherData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLocationHeader(),
          Text(
            "${_weatherData!.current.temperature}°C",
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            decodeWMO(_weatherData!.current.weatherCode),
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 10),
          Text(
            "${_weatherData!.current.windSpeed} km/h",
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  // TAB 2: Today (List of 24h data)
  Widget _buildTodayTab() {
    if (_errorText.isNotEmpty) {
      return Center(child: Padding(padding: const EdgeInsets.all(20), child: Text(_errorText, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center)));
    }
    if (_weatherData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        const SizedBox(height: 20),
        _buildLocationHeader(),
        Expanded(
          child: ListView.builder(
            itemCount: _weatherData!.hourly.length,
            itemBuilder: (context, index) {
              final h = _weatherData!.hourly[index];
              final timeString = h.time.length >= 16 ? h.time.substring(11, 16) : h.time;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                child: Row(
                  children: [
                    // 1. Time
                    Expanded(
                      flex: 1,
                      child: Text(timeString, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                    // 2. Temperature
                    Expanded(
                      flex: 1,
                      child: Text("${h.temperature}°C", textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
                    ),
                    // 3. Description
                    Expanded(
                      flex: 2,
                      child: Text(decodeWMO(h.weatherCode), textAlign: TextAlign.center, style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis),
                    ),
                    // 4. Wind Speed
                    Expanded(
                      flex: 1,
                      child: Text("${h.windSpeed} km/h", textAlign: TextAlign.right, style: const TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // TAB 3: Weekly (List of 7 days)
  Widget _buildWeeklyTab() {
    if (_errorText.isNotEmpty) {
      return Center(child: Padding(padding: const EdgeInsets.all(20), child: Text(_errorText, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center)));
    }
    if (_weatherData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        const SizedBox(height: 20),
        _buildLocationHeader(),
        Expanded(
          child: ListView.builder(
            itemCount: _weatherData!.daily.length,
            itemBuilder: (context, index) {
              final d = _weatherData!.daily[index];
              return ListTile(
                leading: SizedBox(width: 80, child: Text(d.date, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                title: Text("${d.minTemp}°C / ${d.maxTemp}°C", textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
                trailing: SizedBox(
                  width: 100, 
                  child: Text(decodeWMO(d.weatherCode), style: const TextStyle(fontSize: 14), textAlign: TextAlign.right)
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
