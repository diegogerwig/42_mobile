import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MainWeatherLayout extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback onGeolocationPressed;
  final Widget body;

  const MainWeatherLayout({
    super.key,
    required this.searchController,
    this.onSearchChanged,
    this.onSearchSubmitted,
    required this.onGeolocationPressed,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          title: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            onSubmitted: onSearchSubmitted,
            style: const TextStyle(color: AppTheme.textColor),
            decoration: const InputDecoration(
              hintText: "Search location...",
              hintStyle: TextStyle(color: AppTheme.hintColor),
              border: InputBorder.none,
              icon: Icon(Icons.search, color: AppTheme.textColor),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.near_me, color: AppTheme.textColor),
              onPressed: onGeolocationPressed,
            ),
          ],
        ),
        body: body,
        bottomNavigationBar: const BottomAppBar(
          color: AppTheme.primaryColor,
          padding: EdgeInsets.zero,
          child: TabBar(
            labelColor: AppTheme.textColor,
            unselectedLabelColor: AppTheme.unselectedTabColor,
            indicatorColor: AppTheme.textColor,
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
}
