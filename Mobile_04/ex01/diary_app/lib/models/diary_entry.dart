import 'package:flutter/material.dart';

enum Feeling { happy, neutral, sad, angry, surprised }

class DiaryEntry {
  final String id;
  final String userEmail;
  final DateTime date;
  final String title;
  final Feeling feeling;
  final String content;

  DiaryEntry({
    required this.id,
    required this.userEmail,
    required this.date,
    required this.title,
    required this.feeling,
    required this.content,
  });

  IconData get feelingIcon {
    switch (feeling) {
      case Feeling.happy: return Icons.sentiment_very_satisfied;
      case Feeling.neutral: return Icons.sentiment_neutral;
      case Feeling.sad: return Icons.sentiment_very_dissatisfied;
      case Feeling.angry: return Icons.sentiment_dissatisfied;
      case Feeling.surprised: return Icons.sentiment_satisfied;
    }
  }

  Color get feelingColor {
    switch (feeling) {
      case Feeling.happy: return Colors.green;
      case Feeling.neutral: return Colors.grey;
      case Feeling.sad: return Colors.blue;
      case Feeling.angry: return Colors.red;
      case Feeling.surprised: return Colors.orange;
    }
  }
}

// Simulated Database
class MockDatabase {
  static final List<DiaryEntry> entries = [
    DiaryEntry(
      id: "1",
      userEmail: "test@gmail.com",
      date: DateTime.now().subtract(const Duration(days: 1)),
      title: "My first diary entry",
      feeling: Feeling.happy,
      content: "Today I started working on Mobile_04. It feels great to build the Diary app!",
    )
  ];
}
