import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import 'dart:math';

class EntryFormScreen extends StatefulWidget {
  final String userEmail;
  const EntryFormScreen({super.key, required this.userEmail});

  @override
  State<EntryFormScreen> createState() => _EntryFormScreenState();
}

class _EntryFormScreenState extends State<EntryFormScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  Feeling _selectedFeeling = Feeling.happy;

  void _saveEntry() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Title and Content cannot be empty")));
      return;
    }
    
    final newEntry = DiaryEntry(
      id: Random().nextInt(1000000).toString(),
      userEmail: widget.userEmail,
      date: DateTime.now(),
      title: _titleController.text,
      feeling: _selectedFeeling,
      content: _contentController.text,
    );

    MockDatabase.entries.add(newEntry);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("New Entry"),
        backgroundColor: const Color(0xFF22C55E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveEntry,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Feeling>(
              value: _selectedFeeling,
              decoration: const InputDecoration(labelText: "Feeling", border: OutlineInputBorder()),
              items: Feeling.values.map((f) => DropdownMenuItem(
                value: f,
                child: Row(
                  children: [
                    Icon(DiaryEntry(id:'', userEmail:'', date:DateTime.now(), title:'', feeling:f, content:'').feelingIcon, color: DiaryEntry(id:'', userEmail:'', date:DateTime.now(), title:'', feeling:f, content:'').feelingColor),
                    const SizedBox(width: 8),
                    Text(f.name.toUpperCase()),
                  ],
                ),
              )).toList(),
              onChanged: (val) {
                if (val != null) setState(() { _selectedFeeling = val; });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(labelText: "Dear Diary...", border: OutlineInputBorder(), alignLabelWithHint: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
