import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import 'entry_form_screen.dart';
import 'entry_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userEmail;
  const ProfileScreen({super.key, required this.userEmail});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _refreshList() {
    setState(() {});
  }

  void _deleteEntry(String id) {
    setState(() {
      MockDatabase.entries.removeWhere((e) => e.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userEntries = MockDatabase.entries.where((e) => e.userEmail == widget.userEmail).toList();
    userEntries.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      appBar: AppBar(
        title: const Text("My Diary"),
        backgroundColor: const Color(0xFF22C55E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pop(context),
            tooltip: "Logout",
          )
        ],
      ),
      body: userEntries.isEmpty
          ? const Center(child: Text("No entries yet. Create one!", style: TextStyle(color: Colors.grey, fontSize: 18)))
          : ListView.builder(
              itemCount: userEntries.length,
              itemBuilder: (context, index) {
                final entry = userEntries[index];
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
                      onPressed: () => _deleteEntry(entry.id),
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
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF22C55E),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EntryFormScreen(userEmail: widget.userEmail)),
          );
          _refreshList();
        },
      ),
    );
  }
}
