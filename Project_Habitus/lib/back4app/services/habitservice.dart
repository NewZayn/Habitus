import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:newapp/back4app/application.properties.dart';

class HabitService {
  Future<void> initializeParse() async {
    ConfigurationValues configurationValues = ConfigurationValues();
    await Parse().initialize(
      configurationValues.keyApplicationId,
      configurationValues.keyParseServerUrl,
      clientKey: configurationValues.keyClientKey,
      debug: true,
    );
  }

  Future<ParseObject> createHabit({
    required String title,
    required String description,
    required String category,
    DateTime? startDate,
    bool isCompleted = false,
    bool isOverdue = false,
  }) async {
    final user = await ParseUser.currentUser();
    if (user == null) {
      throw Exception("User not logged in");
    }

    final habit = ParseObject('Habit')
      ..set('title', title)
      ..set('description', description)
      ..set('category', category)
      ..set('user', user)
      ..set('isCompleted', isCompleted)
      ..set('isOverdue', isOverdue);

    if (startDate != null) {
      habit.set('startDate', startDate);
      if (DateTime.now().isAfter(startDate)) {
        habit.set('isOverdue', true);
      }
    }

    final response = await habit.save();

    if (!response.success) {
      throw Exception(response.error?.message ?? 'Failed to create habit');
    }

    return habit;
  }

  Future<void> checkAndUpdateOverdueHabits() async {
    final user = await ParseUser.currentUser();
    if (user == null) {
      throw Exception("User not logged in");
    }

    final QueryBuilder<ParseObject> query = QueryBuilder<ParseObject>(ParseObject('Habit'))
      ..whereEqualTo('user', user)
      ..whereEqualTo('isCompleted', false)
      ..whereEqualTo('isOverdue', false);

    final ParseResponse apiResponse = await query.query();
    print("Consulta de hábitos não concluídos e não atrasados realizada.");

    if (apiResponse.success && apiResponse.results != null) {
      final List<ParseObject> habits = apiResponse.results as List<ParseObject>;
      for (final habit in habits) {
        final startDate = habit.get<DateTime>('startDate');

        if (startDate != null) {
          print('Verificando hábito: ${habit.get<String>('title')} com data de início: $startDate');

          if (DateTime.now().isAfter(startDate)) {
            print('O hábito ${habit.get<String>('title')} está atrasado.');
            habit.set('isOverdue', true);
            final updateResponse = await habit.save();
            if (updateResponse.success) {
              print('O campo isOverdue foi atualizado para true para o hábito: ${habit.get<String>('title')}');
            } else {
              print('Erro ao atualizar o campo isOverdue para o hábito: ${habit.get<String>('title')}, erro: ${updateResponse.error?.message}');
            }
          }
        } else {
          print('Hábito ${habit.get<String>('title')} não tem data de início definida.');
        }
      }
    } else {
      print('Nenhum hábito encontrado para atualizar.');
    }
  }

  Future<List<ParseObject>> getHabits() async {
    final user = await ParseUser.currentUser();
    if (user == null) {
      throw Exception("User not logged in");
    }

    await checkAndUpdateOverdueHabits();

    final QueryBuilder<ParseObject> query = QueryBuilder<ParseObject>(ParseObject('Habit'))
      ..whereEqualTo('user', user)
      ..whereEqualTo('isCompleted', false)
      ..orderByAscending('startDate');

    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      print('Resposta Bruta de Hábitos do Back4App: ${apiResponse.results}');
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<ParseObject?> getNextHabit() async {
    final user = await ParseUser.currentUser();
    if (user == null) {
      throw Exception("User not logged in");
    }

    final QueryBuilder<ParseObject> query = QueryBuilder<ParseObject>(ParseObject('Habit'))
      ..whereEqualTo('user', user)
      ..whereEqualTo('isCompleted', false)
      ..orderByAscending('startDate')
      ..setLimit(1);

    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null && apiResponse.results!.isNotEmpty) {
      return apiResponse.results!.first as ParseObject;
    } else {
      return null;
    }
  }

  Future<List<ParseObject>> getHabitsConcluid() async {
    final user = await ParseUser.currentUser();
    if (user == null) {
      throw Exception("User not logged in");
    }

    final QueryBuilder<ParseObject> query = QueryBuilder<ParseObject>(ParseObject('Habit'))
      ..whereEqualTo('user', user)
      ..whereEqualTo('isCompleted', true);

    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      print('Resposta Bruta de Hábitos do Back4App: ${apiResponse.results}');
      return apiResponse.results as List<ParseObject>;
    } else {
      print("Error 132");
      return [];
    }
  }

  Future<void> updateHabit(ParseObject habit) async {
    final ParseResponse response = await habit.save();

    if (!response.success) {
      throw Exception(response.error?.message ?? 'Failed to update habit');
    }
  }
  
}


