import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class UserService {
  Future<ParseUser?> getCurrentUser() async {
    return await ParseUser.currentUser() as ParseUser?;
  }

  Future<void> updateUser(String username, String email) async {
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user != null) {
      user.username = username;
      user.emailAddress = email;
      final response = await user.save();

      if (!response.success) {
        throw Exception(response.error?.message);
      }
    }
  }
}
