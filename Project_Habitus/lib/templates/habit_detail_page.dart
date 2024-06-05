import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:intl/intl.dart'; // For date formatting

class HabitDetailPage extends StatefulWidget {
  final ParseObject habit;

  const HabitDetailPage({required this.habit, Key? key}) : super(key: key);

  @override
  _HabitDetailPageState createState() => _HabitDetailPageState();
}

class _HabitDetailPageState extends State<HabitDetailPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late bool isCompleted;
  late bool isOverdue;
  DateTime? _startDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.habit.get<String>('title'));
    descriptionController = TextEditingController(text: widget.habit.get<String>('description'));
    isCompleted = widget.habit.get<bool>('isCompleted') ?? false;
    _startDate = widget.habit.get<DateTime>('startDate'); // Get the initial start date
    isOverdue = _startDate != null && _startDate!.isBefore(DateTime.now()); // Calculate initial overdue status
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Hábito'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),


            // Date Picker
            ListTile(
              title: const Text('Data de Início'),
              subtitle: Text(_startDate != null ? DateFormat('dd/MM/yyyy').format(_startDate!) : 'Selecione uma data'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _startDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != _startDate) {
                  setState(() {
                    _startDate = picked;
                    widget.habit.set('startDate', picked);

                    // Update 'isOverdue' based on the new date
                    isOverdue = _startDate!.isBefore(DateTime.now());
                    widget.habit.set('isOverdue', isOverdue);
                  });
                }
              },
            ),

            SwitchListTile(
              title: const Text('Concluído'),
              value: isCompleted,
              onChanged: (bool newValue) async {
                setState(() {
                  isCompleted = newValue;
                });

                widget.habit.set('isCompleted', newValue);

                try {
                  await widget.habit.save();
                } catch (e) {
                  // Handle error here if needed
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao salvar o hábito: $e')));
                }
              },
            ),
            SwitchListTile(
              title: const Text('Atrasado'),
              value: isOverdue,
              onChanged: (bool newValue) async {
                if (!newValue && _startDate!.isBefore(DateTime.now())) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Atenção'),
                      content: const Text(
                          'O hábito ainda está atrasado. Por favor, atualize a data de início para uma data futura.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                setState(() {
                  isOverdue = newValue;
                });

                widget.habit.set('isOverdue', newValue);

                try {
                  await widget.habit.save();
                } catch (e) {
                  // Handle error here if needed
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao salvar o hábito: $e')));
                }
              },
            ),

            ElevatedButton(
              onPressed: () async {
                widget.habit
                  ..set('title', titleController.text)
                  ..set('description', descriptionController.text)
                  ..set('startDate', _startDate);

                try {
                  await widget.habit.save();
                  Navigator.pop(context, true);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao salvar o hábito: $e')));
                }
              },
              child: const Text('Salvar Mudanças'),
            ),
          ],
        ),
      ),
    );
  }
}

