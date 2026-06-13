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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
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
    return DefaultTabController(
      length: 3, // Currently, Today, Weekly
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF455A64),  // Blue Grey 700
          title: const TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search location...",
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
              icon: Icon(Icons.search, color: Colors.white),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.near_me, color: Colors.white),
              onPressed: () {
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
        bottomNavigationBar: const BottomAppBar(
          color: Color(0xFF90A4AE),  // Blue Grey 300
          padding: EdgeInsets.zero,
          child: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
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
