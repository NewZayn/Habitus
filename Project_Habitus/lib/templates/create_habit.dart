import 'package:flutter/material.dart';
import 'package:newapp/back4app/services/habitservice.dart';

class CreateHabitWidget extends StatefulWidget {
  const CreateHabitWidget({super.key});

  @override
  _CreateHabitWidgetState createState() => _CreateHabitWidgetState();
}

class _CreateHabitWidgetState extends State<CreateHabitWidget> {
  final HabitService habitService = HabitService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController reminderController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController urgencyController = TextEditingController();
  final TextEditingController subtasksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const Text(
                  'Criar',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 48), // Placeholder to balance the row
              ],
            ),
            const Center(
              child: Text('Novo Hábito',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.0,
              children: List<Widget>.generate(10, (int index) {
                return ChoiceChip(
                  label: Text('Color $index'),
                  selected: false,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  labelText: 'Título',
                  suffixIcon: Icon(Icons.title)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  labelText: 'Data',
                  suffixIcon: Icon(Icons.calendar_today)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  labelText: 'Horário',
                  suffixIcon: Icon(Icons.access_time)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: reminderController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  labelText: 'Lembrete',
                  suffixIcon: Icon(Icons.notifications)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  labelText: 'Categoria',
                  suffixIcon: Icon(Icons.category)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: urgencyController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  labelText: 'Urgência',
                  suffixIcon: Icon(Icons.warning)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: subtasksController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  labelText: 'Subtarefas',
                  suffixIcon: Icon(Icons.add)),
            ),
            const SizedBox(height: 8),
            IconButton(
              icon: const Icon(Icons.mic),
              onPressed: () {
                // Add your microphone logic here
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final habitData = {
                  'title': titleController.text,
                  'date': dateController.text,
                  'time': timeController.text,
                  'reminder': reminderController.text,
                  'category': categoryController.text,
                  'urgency': urgencyController.text,
                  'subtasks': subtasksController.text,
                };

                try {
                  await habitService.createHabit(habitData as String);
                  Navigator.of(context).pop();
                } catch (e) {
                  print(e);
                }
              },
              child: const Text('Salvar Hábito'),
            ),
          ],
        ),
      ),
    );
  }
}
