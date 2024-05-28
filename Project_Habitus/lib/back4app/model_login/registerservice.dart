import 'package:flutter/material.dart';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class RegisterService {
  final String keyApplicationId = 'esp712BcP9FVhhEIfY1V8fYB6anToaZHIzPk6XMb';
  final String keyClientKey = 'Y86zzXZrINPFoesCDrqwWU7s9VZ26rOHwB7ni6nK';
  final String keyParseServerUrl = 'https://parseapi.back4app.com';

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Parse().initialize(
      keyApplicationId,
      keyParseServerUrl,
      clientKey: keyClientKey,
      debug: true,
    );
  }

  Future<ParseUser> registerUser(
      String username, String password, String email) async {
    final user = ParseUser.createUser(username, password, email);
    final response = await user.signUp();

    if (response.success) {
      return user;
    } else {
      throw Exception(response.error?.message);
    }
  }
}
