import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../back4app/services/habitservice.dart'; // Add import for HabitService
import 'habit_detail_page.dart';

class CompletedHabitsPage extends StatefulWidget {
  const CompletedHabitsPage({Key? key, required List<ParseObject> completedHabits}) : super(key: key);

  @override
  _CompletedHabitsPageState createState() => _CompletedHabitsPageState();
}

class _CompletedHabitsPageState extends State<CompletedHabitsPage> {
  final HabitService habitService = HabitService();
  List<ParseObject> completedHabits = []; // Use a list to store completed habits

  @override
  void initState() {
    super.initState();
    fetchCompletedHabits(); // Fetch completed habits when the page loads
  }

  Future<void> fetchCompletedHabits() async {
    try {
      final fetchedHabits = await habitService.getHabitsConcluid();
      setState(() {
        completedHabits = fetchedHabits;
      });
    } catch (e) {
      print('Error fetching completed habits: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hábitos Concluídos'),
        backgroundColor: Colors.green,
      ),
      body: completedHabits.isEmpty
          ? const Center(child: Text('Não há hábitos concluídos ainda'))
          : ListView.builder(
        itemCount: completedHabits.length,
        itemBuilder: (context, index) {
          final habit = completedHabits[index];
          return ListTile(
            title: Text(habit.get<String>('title') ?? 'Sem Título'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HabitDetailPage(habit: habit),
                ),
              );
            },
            trailing: const Icon(Icons.check, color: Colors.green),
          );
        },
      ),
    );
  }
}

