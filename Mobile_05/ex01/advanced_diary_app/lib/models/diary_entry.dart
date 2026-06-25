import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  static DiaryEntry? tryParse(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return null;

      final rawFeeling = data['feeling'];
      if (rawFeeling is! String || !Feeling.values.any((e) => e.name == rawFeeling)) {
        return null;  // Discard if format is invalid
      }

      final rawDate = data['date'];
      if (rawDate is! Timestamp) {
        return null;  // Discard if format is invalid
      }

      return DiaryEntry(
        id: doc.id,
        userEmail: data['userEmail']?.toString() ?? '',
        date: rawDate.toDate(),
        title: data['title']?.toString() ?? '',
        feeling: Feeling.values.firstWhere((e) => e.name == rawFeeling),
        content: data['content']?.toString() ?? '',
      );
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userEmail': userEmail,
      'date': Timestamp.fromDate(date),
      'title': title,
      'feeling': feeling.name,
      'content': content,
    };
  }
}
