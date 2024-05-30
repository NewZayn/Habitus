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

  Future<List<ParseObject>> getHabits() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user == null) {
      throw Exception('Usuário não logado');
    }

    final query = QueryBuilder<ParseObject>(ParseObject('Habit'))
      ..whereEqualTo('user', user);

    final ParseResponse response = (await query.find()) as ParseResponse;

    if (response.success && response.results != null) {
      return response.results as List<ParseObject>;
    } else {
      throw Exception(response.error?.message ?? 'Falha ao buscar hábitos');
    }
  }

  Future<void> createHabit(String title) async {
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user == null) {
      throw Exception('Usuário não logado');
    }

    final habit = ParseObject('Habit')
      ..set('title', title)
      ..set('user', user);

    final ParseResponse response = await habit.save();

    if (!response.success) {
      throw Exception(response.error?.message ?? 'Falha ao criar hábito');
    }
  }
}
