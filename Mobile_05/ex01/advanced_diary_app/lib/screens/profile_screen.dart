import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/diary_entry.dart';
import 'entry_form_screen.dart';
import 'entry_detail_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String userEmail;
  const ProfileScreen({super.key, required this.userEmail});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('advanced_entries')
              .where('userEmail', isEqualTo: userEmail)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Color(0xFF22C55E)));
            
            final docs = snapshot.data?.docs ?? [];
            final entries = docs.map((d) => DiaryEntry.fromFirestore(d)).toList();
            
            // Sort by date descending
            entries.sort((a, b) => b.date.compareTo(a.date));
            
            // Calculate percentages
            final int totalEntries = entries.length;
            final Map<Feeling, int> feelingCounts = {};
            for (var f in Feeling.values) { feelingCounts[f] = 0; }
            for (var e in entries) {
              feelingCounts[e.feeling] = (feelingCounts[e.feeling] ?? 0) + 1;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: FirebaseAuth.instance.currentUser?.photoURL != null 
                                ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                                : const NetworkImage('https://cdn-icons-png.flaticon.com/512/3135/3135715.png') as ImageProvider,
                            backgroundColor: Colors.transparent,
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(FirebaseAuth.instance.currentUser?.displayName ?? userEmail.split('@').first, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                              const SizedBox(height: 4),
                              if (FirebaseAuth.instance.currentUser?.providerData.isNotEmpty == true)
                                Row(
                                  children: [
                                    FirebaseAuth.instance.currentUser!.providerData.first.providerId == 'google.com'
                                        ? const FaIcon(FontAwesomeIcons.google, size: 14, color: Colors.grey)
                                        : (FirebaseAuth.instance.currentUser!.providerData.first.providerId == 'github.com'
                                            ? const FaIcon(FontAwesomeIcons.github, size: 14, color: Colors.grey)
                                            : const SizedBox.shrink()),
                                    const SizedBox(width: 6),
                                    Text(FirebaseAuth.instance.currentUser!.providerData.first.providerId == 'google.com' ? "Google" : "GitHub", style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic)),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.grey),
                        onPressed: () => _logout(context),
                        tooltip: "Logout",
                      )
                    ],
                  ),
                  const SizedBox(height: 24),

                  // "Your last diary entries"
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6EE7B7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text("Your last diary entries", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF064E3B), fontStyle: FontStyle.italic)),
                  ),
                  const SizedBox(height: 8),
                  
                  if (entries.isEmpty)
                    const Padding(padding: EdgeInsets.all(16.0), child: Center(child: Text("No entries yet", style: TextStyle(color: Colors.grey))))
                  else
                    ...entries.take(2).map((entry) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFF6EE7B7))),
                      child: ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${entry.date.day}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("${entry.date.month}/${entry.date.year}", style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                        title: Row(
                          children: [
                            Icon(entry.feelingIcon, color: entry.feelingColor),
                            const SizedBox(width: 12),
                            Expanded(child: Text(entry.title, style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic))),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => EntryDetailScreen(entry: entry)),
                          );
                        },
                      ),
                    )),

                  const SizedBox(height: 24),

                  // "Your feel for your X entries"
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA7F3D0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text("Your feel for your $totalEntries entries", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF064E3B), fontStyle: FontStyle.italic)),
                  ),
                  const SizedBox(height: 8),
                  
                  // Percentages
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFA7F3D0), width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: Feeling.values.map((f) {
                        double percentage = totalEntries == 0 ? 0 : (feelingCounts[f]! / totalEntries) * 100;
                        final dummy = DiaryEntry(id: '', userEmail: '', date: DateTime.now(), title: '', feeling: f, content: '');
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(dummy.feelingIcon, color: dummy.feelingColor),
                              const SizedBox(width: 16),
                              Text("${percentage.toStringAsFixed(0)}%", style: const TextStyle(fontSize: 16, color: Colors.grey)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),
                  
                  // Add New Entry Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EntryFormScreen(userEmail: userEmail)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF22C55E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text("New diary entry", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
