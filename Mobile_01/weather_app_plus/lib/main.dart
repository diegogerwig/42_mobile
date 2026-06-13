import 'package:flutter/material.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App+',
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
  // Store the searched text or geolocation
  String _searchText = "";
  final TextEditingController _searchController = TextEditingController();

  void _onSearchSubmitted(String value) {
    setState(() {
      _searchText = value; // Update state with typed text
    });
  }

  void _onGeolocationPressed() {
    setState(() {
      _searchText = "Geolocation"; // Override with 'Geolocation' string
    });
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
            onSubmitted: _onSearchSubmitted, // Triggers when "enter/search" is pressed on keyboard
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

  // Helper method to build the content of each tab dynamically
  Widget _buildTabContent(String tabName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            tabName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          // Only show the second text line if the user has triggered a search or geolocation
          if (_searchText.isNotEmpty) ...[
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
