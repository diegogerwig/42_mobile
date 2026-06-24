import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/diary_entry.dart';

class EntryDetailScreen extends StatelessWidget {
  final DiaryEntry entry;
  const EntryDetailScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      appBar: AppBar(
        title: Text(entry.title),
        backgroundColor: const Color(0xFF22C55E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              try {
                await FirebaseFirestore.instance.collection('advanced_entries').doc(entry.id).delete();
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error deleting: $e")));
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(entry.feelingIcon, color: entry.feelingColor, size: 32),
                const SizedBox(width: 12),
                Text(
                  "${entry.date.day}/${entry.date.month}/${entry.date.year}",
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
            const Divider(height: 30),
            Text(
              entry.content,
              style: const TextStyle(fontSize: 18, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
