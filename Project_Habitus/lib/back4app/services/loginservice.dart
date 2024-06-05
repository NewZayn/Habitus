// loginservice.dart
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:newapp/back4app/application.properties.dart';

class LoginService {
  Future<void> initializeParse() async {
    ConfigurationValues configurationValues = ConfigurationValues();
    await Parse().initialize(
      configurationValues.keyApplicationId,
      configurationValues.keyParseServerUrl,
      clientKey: configurationValues.keyClientKey,
      debug: true,
    );
  }

  Future<ParseUser?> loginUser(String username, String password) async {
    final user = ParseUser(username, password, null);
    final response = await user.login();

    if (response.success) {
      return user;
    } else {
      throw Exception(response.error?.message);
    }
  }

  Future<void> logoutUser() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user != null) {
      final response = await user.logout();

      if (!response.success) {
        throw Exception(response.error?.message);
      }
    }
  }
}
