import 'package:flutter/material.dart';
import 'profile_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _startAuthFlow(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Welcome", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Log in to continue to your diary.", style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 24),
              _buildAuthButton(
                icon: Icons.g_mobiledata,
                text: "Continue with Google",
                onPressed: () {
                  Navigator.pop(context); // Cierra el modal
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfileScreen(userEmail: "test@gmail.com")));
                },
              ),
              const SizedBox(height: 12),
              _buildAuthButton(
                icon: Icons.code,
                text: "Continue with GitHub",
                onPressed: () {
                  Navigator.pop(context); // Cierra el modal
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfileScreen(userEmail: "github_user@mail.com")));
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAuthButton({required IconData icon, required String text, required VoidCallback onPressed}) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white30),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            const Text(
              "Welcome to your\nDiary",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                color: Color(0xFF14532D),
              ),
            ),
            const Spacer(flex: 2),
            ElevatedButton(
              onPressed: () => _startAuthFlow(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 4,
              ),
              child: const Text("Login", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
