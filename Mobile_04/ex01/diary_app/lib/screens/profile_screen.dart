import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  void _deleteEntry(BuildContext context, String docId) async {
    try {
      await FirebaseFirestore.instance.collection('entries').doc(docId).delete();
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Delete Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      appBar: AppBar(
        title: const Text("My Diary"),
        backgroundColor: const Color(0xFF22C55E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: "Logout",
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('entries')
            .where('userEmail', isEqualTo: userEmail)
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Please create index in Firebase for orderBy date!', style: const TextStyle(color: Colors.red), textAlign: TextAlign.center));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Color(0xFF22C55E)));
          
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text("No entries yet. Create one!", style: TextStyle(color: Colors.grey, fontSize: 18)));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final entry = DiaryEntry.fromFirestore(docs[index]);
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: entry.feelingColor.withOpacity(0.2),
                    child: Icon(entry.feelingIcon, color: entry.feelingColor),
                  ),
                  title: Text(entry.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${entry.date.day}/${entry.date.month}/${entry.date.year}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _deleteEntry(context, entry.id),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EntryDetailScreen(entry: entry)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF22C55E),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EntryFormScreen(userEmail: userEmail)),
          );
        },
      ),
    );
  }
}
