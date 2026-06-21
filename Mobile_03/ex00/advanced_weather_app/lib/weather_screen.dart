import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'models.dart';

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
  LocationResult? _selectedLocation;
  WeatherData? _weatherData;

  @override
  void initState() {
    super.initState();
    _fetchLocationAndWeather();
  }

  Future<void> _fetchLocationAndWeather() async {
    setState(() { _errorText = ""; _searchResults.clear(); _searchController.clear(); _weatherData = null; _selectedLocation = null; });
    if (!await Geolocator.isLocationServiceEnabled()) {
      setState(() { _errorText = "Geolocation is not available, please enable it in your App settings"; });
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        setState(() { _errorText = "Geolocation is not available, please enable it in your App settings"; });
        return;
      }
    }
    try {
      Position position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.low));
      final loc = LocationResult(name: "My Location", region: "Current GPS", country: "", latitude: position.latitude, longitude: position.longitude);
      _selectLocation(loc);
    } catch (e) {
      setState(() { _errorText = "Geolocation is not available, please enable it in your App settings"; });
    }
  }

  Future<void> _fetchWeather(LocationResult location) async {
    try {
      final url = Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=${location.latitude}&longitude=${location.longitude}&current=temperature_2m,weather_code,wind_speed_10m&hourly=temperature_2m,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() { _weatherData = WeatherData.fromJson(jsonDecode(response.body)); });
      } else {
        setState(() { _errorText = "The service connection is lost, please check your internet connection or try again later"; });
      }
    } catch (e) {
      setState(() { _errorText = "The service connection is lost, please check your internet connection or try again later"; });
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (query.isEmpty) { setState(() { _searchResults.clear(); }); return; }
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final url = Uri.parse('https://geocoding-api.open-meteo.com/v1/search?name=$query&count=5&language=en&format=json');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final results = data['results'] as List<dynamic>?;
          if (results != null) setState(() { _searchResults = results.map((e) => LocationResult.fromJson(e)).toList(); });
          else setState(() { _searchResults.clear(); });
        }
      } catch (e) { setState(() { _searchResults.clear(); }); }
    });
  }

  Future<void> _onSearchSubmitted(String query) async {
    if (query.isEmpty) return;
    setState(() { _searchResults.clear(); _errorText = ""; });
    try {
      final url = Uri.parse('https://geocoding-api.open-meteo.com/v1/search?name=$query&count=1&language=en&format=json');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List<dynamic>?;
        if (results != null && results.isNotEmpty) _selectLocation(LocationResult.fromJson(results[0]));
        else setState(() { _errorText = "Could not find any result for the supplied address or coordinates."; });
      }
    } catch (e) { setState(() { _errorText = "The service connection is lost, please check your internet connection or try again later"; }); }
  }

  void _selectLocation(LocationResult result) {
    setState(() {
      _searchController.text = result.name == "My Location" ? "" : result.name;
      _searchResults.clear();
      _selectedLocation = result;
      _weatherData = null;
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E2C),
        body: SafeArea(
          child: Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: Stack(
                  children: [
                    TabBarView(children: [_buildCurrentTab(), _buildTodayTab(), _buildWeeklyTab()]),
                    if (_searchResults.isNotEmpty) _buildSuggestionsOverlay(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomAppBar(
          color: Color(0xFF2D2D44),
          padding: EdgeInsets.zero,
          child: TabBar(
            labelColor: Colors.white, unselectedLabelColor: Colors.white54, indicatorColor: Colors.cyanAccent,
            tabs: [Tab(icon: Icon(Icons.wb_sunny_outlined), text: 'Currently'), Tab(icon: Icon(Icons.calendar_today), text: 'Today'), Tab(icon: Icon(Icons.date_range), text: 'Weekly')],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D44),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 3)),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                onSubmitted: _onSearchSubmitted,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: const InputDecoration(
                  icon: Icon(Icons.search, color: Colors.cyanAccent),
                  hintText: 'Search location...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: const BoxDecoration(
              color: Colors.cyanAccent,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.near_me, color: Color(0xFF1E1E2C)),
              onPressed: _fetchLocationAndWeather,
              tooltip: "Use current location",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsOverlay() {
    return Positioned(
      top: 0, left: 16, right: 64,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF3B3B54),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
          ),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            shrinkWrap: true,
            itemCount: _searchResults.length,
            separatorBuilder: (_, __) => const Divider(color: Colors.white12, height: 1),
            itemBuilder: (context, index) {
              final result = _searchResults[index];
              final subtitle = result.region.isNotEmpty ? '${result.region}, ${result.country}' : result.country;
              return ListTile(
                leading: const Icon(Icons.location_on, color: Colors.cyanAccent),
                title: Text(result.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
                onTap: () => _selectLocation(result),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLocationHeader() {
    if (_selectedLocation == null) return const SizedBox.shrink();
    String sub = _selectedLocation!.region.isNotEmpty ? "${_selectedLocation!.region}, ${_selectedLocation!.country}" : _selectedLocation!.country;
    if (sub.startsWith(", ")) sub = sub.substring(2);
    return Column(
      children: [
        Text(_selectedLocation!.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.cyanAccent), textAlign: TextAlign.center),
        if (sub.isNotEmpty) Text(sub, style: const TextStyle(fontSize: 16, color: Colors.white70), textAlign: TextAlign.center),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCurrentTab() {
    if (_errorText.isNotEmpty) return Center(child: Padding(padding: const EdgeInsets.all(20), child: Text(_errorText, style: const TextStyle(color: Colors.redAccent, fontSize: 16), textAlign: TextAlign.center)));
    if (_weatherData == null) return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLocationHeader(),
          Text("${_weatherData!.current.temperature}°C", style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 10),
          Text(decodeWMO(_weatherData!.current.weatherCode), style: const TextStyle(fontSize: 24, color: Colors.white)),
          const SizedBox(height: 10),
          Text("${_weatherData!.current.windSpeed} km/h", style: const TextStyle(fontSize: 20, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildTodayTab() {
    if (_errorText.isNotEmpty) return Center(child: Padding(padding: const EdgeInsets.all(20), child: Text(_errorText, style: const TextStyle(color: Colors.redAccent, fontSize: 16), textAlign: TextAlign.center)));
    if (_weatherData == null) return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
    return Column(
      children: [
        const SizedBox(height: 20), _buildLocationHeader(),
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
                    Expanded(flex: 1, child: Text(timeString, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))),
                    Expanded(flex: 1, child: Text("${h.temperature}°C", textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.cyanAccent))),
                    Expanded(flex: 2, child: Text(decodeWMO(h.weatherCode), textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.white), overflow: TextOverflow.ellipsis)),
                    Expanded(flex: 1, child: Text("${h.windSpeed} km/h", textAlign: TextAlign.right, style: const TextStyle(fontSize: 14, color: Colors.white70))),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyTab() {
    if (_errorText.isNotEmpty) return Center(child: Padding(padding: const EdgeInsets.all(20), child: Text(_errorText, style: const TextStyle(color: Colors.redAccent, fontSize: 16), textAlign: TextAlign.center)));
    if (_weatherData == null) return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
    return Column(
      children: [
        const SizedBox(height: 20), _buildLocationHeader(),
        Expanded(
          child: ListView.builder(
            itemCount: _weatherData!.daily.length,
            itemBuilder: (context, index) {
              final d = _weatherData!.daily[index];
              return ListTile(
                leading: SizedBox(width: 80, child: Text(d.date, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))),
                title: Text("${d.minTemp}°C / ${d.maxTemp}°C", textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.cyanAccent)),
                trailing: SizedBox(width: 100, child: Text(decodeWMO(d.weatherCode), style: const TextStyle(fontSize: 14, color: Colors.white), textAlign: TextAlign.right)),
              );
            },
          ),
        ),
      ],
    );
  }
}
