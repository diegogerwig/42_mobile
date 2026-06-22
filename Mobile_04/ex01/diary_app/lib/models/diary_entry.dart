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

  factory DiaryEntry.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return DiaryEntry(
      id: doc.id,
      userEmail: data['userEmail'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      title: data['title'] ?? '',
      feeling: Feeling.values.firstWhere((e) => e.name == data['feeling'], orElse: () => Feeling.neutral),
      content: data['content'] ?? '',
    );
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
