import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../back4app/services/habitservice.dart';
import 'create_habit_widget.dart';
import 'habit_detail_page.dart';

class HabitsPage extends StatefulWidget {
  final Future<void> Function() onAddHabit;

  const HabitsPage({required this.onAddHabit, Key? key, required List<ParseObject> habits}) : super(key: key);

  @override
  _HabitsPageState createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  List<ParseObject> habits = [];
  ParseObject? nextHabit;

  @override
  void initState() {
    super.initState();
    _loadHabits();
    _loadNextHabit();
  }

  Future<void> _loadHabits() async {
    HabitService habitService = HabitService();
    List<ParseObject> loadedHabits = await habitService.getHabits();
    setState(() {
      habits = loadedHabits;
    });
  }

  Future<void> _loadNextHabit() async {
    HabitService habitService = HabitService();
    ParseObject? habit = await habitService.getNextHabit();
    setState(() {
      nextHabit = habit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Text(
                  nextHabit != null
                      ? 'Próximo Hábito: ${nextHabit!.get<String>('title')}'
                      : 'Hoje',
                  style: TextStyle(fontSize: 24.0),
                ),
                Expanded(
                  child: habits.isEmpty
                      ? const Center(child: Text('Não há hábitos ainda'))
                      : ListView.builder(
                    itemCount: habits.length,
                    itemBuilder: (context, index) {
                      final habit = habits[index];
                      final isCompleted = habit.get<bool>('isCompleted') ?? false;
                      final isOverdue = habit.get<bool>('isOverdue') ?? false;
                      return GestureDetector(
                        onTap: () async {
                          bool? updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HabitDetailPage(habit: habit),
                            ),
                          );
                          if (updated == true) {
                            _loadHabits(); // Refresh habits list if an update occurred
                            _loadNextHabit(); // Refresh next habit
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  habit.get<String>('title') ?? 'Sem Título',
                                  style: const TextStyle(fontSize: 18, color: Colors.cyan),
                                ),
                              ),
                              Icon(
                                Icons.check_circle,
                                color: isCompleted
                                    ? Colors.green
                                    : isOverdue
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton.extended(
            onPressed: () async {
              final newHabit = await showModalBottomSheet<ParseObject>(
                context: context,
                isScrollControlled: true,
                builder: (context) => const CreateHabitWidget(),
              );
              if (newHabit != null) {
                await widget.onAddHabit();
                _loadHabits();
                _loadNextHabit();
              }
            },
            label: const Text('Criar Hábito'),
            icon: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
