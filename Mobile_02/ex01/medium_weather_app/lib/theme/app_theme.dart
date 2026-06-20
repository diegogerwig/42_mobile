import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF455A64);
  static const Color textColor = Colors.white;
  static const Color hintColor = Colors.white70;
  static const Color unselectedTabColor = Colors.white54;

  static ThemeData get theme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: primaryColor,
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: textColor,
        unselectedLabelColor: unselectedTabColor,
        indicatorColor: textColor,
      ),
    );
  }
}
