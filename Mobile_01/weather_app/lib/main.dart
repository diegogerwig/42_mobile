import 'package:flutter/material.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey[700], 
          foregroundColor: Colors.white,
        ),
        bottomAppBarTheme: const BottomAppBarTheme(
          color: Colors.blueGrey[700], 
        ),
      ),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // DefaultTabController manages the state for the TabBar and TabBarView automatically.
    // It enables swiping between tabs without writing manual state logic.
    return DefaultTabController(
      length: 3, // Currently, Today, Weekly
      child: Scaffold(
        appBar: AppBar(
          title: const TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search location...",
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none, // Removes the underline
              icon: Icon(Icons.search, color: Colors.white),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.near_me, color: Colors.white),
              onPressed: () {
                // Geolocation action to be implemented in the future
              },
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            Center(
              child: Text(
                "Currently",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                "Today",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                "Weekly",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        // The subject specifically requests using BottomAppBar
        bottomNavigationBar: const BottomAppBar(
          padding: EdgeInsets.zero, // Removes default inner padding
          child: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.wb_sunny_outlined),
                text: 'Currently',
              ),
              Tab(
                icon: Icon(Icons.calendar_today),
                text: 'Today',
              ),
              Tab(
                icon: Icon(Icons.date_range),
                text: 'Weekly',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
