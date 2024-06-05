import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../back4app/services/habitservice.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({Key? key}) : super(key: key);

  @override
  _CalendarioPageState createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<ParseObject>> _habitsByDate = {};
  HabitService _habitService = HabitService();

  @override
  void initState() {
    super.initState();
    _habitService.initializeParse().then((_) {
      _loadHabits();
    });
  }

  Future<void> _loadHabits() async {
    try {
      List<ParseObject> habits = await _habitService.getHabits();
      Map<DateTime, List<ParseObject>> habitsMap = {};
      for (var habit in habits) {
        DateTime startDate = habit.get<DateTime>('startDate')!;
        DateTime dateOnly = DateTime(startDate.year, startDate.month, startDate.day);
        if (habitsMap.containsKey(dateOnly)) {
          habitsMap[dateOnly]!.add(habit);
        } else {
          habitsMap[dateOnly] = [habit];
        }
      }
      setState(() {
        _habitsByDate = habitsMap;
      });
    } catch (e) {
      print("Failed to load habits: $e");
    }
  }

  List<ParseObject> _getHabitsForDay(DateTime day) {
    return _habitsByDate[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Calendário'),
        elevation: 0,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
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
            eventLoader: _getHabitsForDay,
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView(
              children: _getHabitsForDay(_selectedDay).map((habit) {
                return ListTile(
                  title: Text(habit.get<String>('title') ?? 'Sem Título'),
                  subtitle: Text(habit.get<String>('description') ?? 'Sem Descrição'),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action to add a new event
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

