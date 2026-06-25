import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/diary_entry.dart';
import 'entry_detail_screen.dart';

class AgendaScreen extends StatefulWidget {
  final String userEmail;
  const AgendaScreen({super.key, required this.userEmail});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      appBar: AppBar(
        title: const Text('Agenda', style: TextStyle(color: Color(0xFF064E3B), fontStyle: FontStyle.italic)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: Color(0xFF3B82F6),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Divider(thickness: 2),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('advanced_entries')
                  .where('userEmail', isEqualTo: widget.userEmail)  // Link user accounts
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF22C55E)));
                }

                final docs = snapshot.data?.docs ?? [];
                final allEntries = docs.map((d) => DiaryEntry.tryParse(d)).whereType<DiaryEntry>().toList();

                final selectedEntries = allEntries.where((e) => isSameDay(e.date, _selectedDay)).toList();
                
                selectedEntries.sort((a, b) => b.date.compareTo(a.date));

                if (selectedEntries.isEmpty) {
                  return const Center(child: Text("No entries for this date.", style: TextStyle(color: Colors.grey)));
                }

                return ListView.builder(
                  itemCount: selectedEntries.length,
                  itemBuilder: (context, index) {
                    final entry = selectedEntries[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
