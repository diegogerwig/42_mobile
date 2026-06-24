import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'agenda_screen.dart';

class MainScreen extends StatefulWidget {
  final String userEmail;
  const MainScreen({super.key, required this.userEmail});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      ProfileScreen(userEmail: widget.userEmail),
      AgendaScreen(userEmail: widget.userEmail),
    ];
  }

  Widget _buildNavButton({required IconData icon, required String label, required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF14532D) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF14532D) : const Color(0xFF6EE7B7), width: 2),
          boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF14532D).withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3))] : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : const Color(0xFF064E3B)),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ]
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          color: const Color(0xFFF0FDF4), // Mismo color de fondo para que parezcan flotantes
          child: Row(
            children: [
              Expanded(
                child: _buildNavButton(
                  icon: Icons.person,
                  label: "Profile",
                  isSelected: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildNavButton(
                  icon: Icons.calendar_today,
                  label: "Agenda",
                  isSelected: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
