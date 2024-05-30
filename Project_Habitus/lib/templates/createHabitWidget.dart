import 'package:flutter/material.dart';
import 'package:newapp/back4app/services/habitservice.dart';

class CreateHabitWidget extends StatefulWidget {
  const CreateHabitWidget({super.key});

  @override
  _CreateHabitWidgetState createState() => _CreateHabitWidgetState();
}

class _CreateHabitWidgetState extends State<CreateHabitWidget> {
  final TextEditingController _titleController = TextEditingController();
  final HabitService habitService = HabitService();
  bool _isLoading = false;

  Future<void> _createHabit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await habitService.createHabit(_titleController.text);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao criar hábito: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.0,
        right: 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 16.0),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Título do Hábito'),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _isLoading ? null : _createHabit,
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Criar Hábito'),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
