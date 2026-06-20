import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // Store the searched text, GPS coordinates, or error message
  String _searchText = "";
  String _errorText = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // The subject demands determining location when the application starts
    _fetchLocation();
  }

  // Method to check permissions and get device's GPS coordinates
  Future<void> _fetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    setState(() {
      _errorText = "";
    });

    // Check if GPS is enabled on the device
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _errorText = "Geolocation is not available, please enable it in your App settings";
      });
      return;
    }

    // Check app permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try requesting permissions again
        setState(() {
          _errorText = "Geolocation is not available, please enable it in your App settings";
        });
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      setState(() {
        _errorText = "Geolocation is not available, please enable it in your App settings";
      });
      return;
    } 

    // If we reach here, permissions are granted, fetch position!
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.low)
      );
      setState(() {
        // Clear search text from manual searches to show GPS
        _searchController.clear();
        _searchText = "${position.latitude} ${position.longitude}";
      });
    } catch (e) {
      setState(() {
        _errorText = "Geolocation is not available, please enable it in your App settings";
      });
    }
  }

  void _onSearchSubmitted(String value) {
    setState(() {
      _errorText = ""; // Clear errors
      _searchText = value;
    });
  }

  void _onGeolocationPressed() {
    // When the user clicks the geolocation button, fetch location again
    _fetchLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF455A64), // Constant BlueGrey 700
          title: TextField(
            controller: _searchController,
            onSubmitted: _onSearchSubmitted, // Triggers on enter
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
              onPressed: _onGeolocationPressed,
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildTabContent("Currently"),
            _buildTabContent("Today"),
            _buildTabContent("Weekly"),
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

  // Build the content depending on the state (Error vs Normal Data)
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
