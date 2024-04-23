import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

final keyApplicationId = 'dA9iQuXlEF700vefoWI7nwCHALI133HU5Utkbdaf';
final keyClientKey = 'tPMQ2K87ulZZl049jDp0e5FjSr8WKEsBVhCj3OUA';
final keyParseServerUrl = 'https://parseapi.back4app.com';

class User {
  String? objectId;
  bool? emailVerified;
  ParseACL? acl;
  DateTime? updatedAt;
  DateTime? createdAt;
  String? email;

  User({
    this.objectId,
    this.emailVerified,
    this.acl,
    this.updatedAt,
    this.createdAt,
    this.email,
  });

  static Future<User?> register(String email, String password) async {
    try {
      final user = ParseUser(email, password, null);

      // Set email verification to false by default
      user.set<bool>('emailVerified', false);

      await user.save();

      final registeredUser = User(
        emailVerified: user.get<bool>('emailVerified'),
        acl: user.get<ParseACL>('ACL'),
        updatedAt: user.updatedAt,
        createdAt: user.createdAt,
        email: email,
      );

      registeredUser.objectId = user.objectId;
      return registeredUser;
    } catch (error) {
      // Handle registration errors
      print('Registration error: $error');
      return null;
    }
  }
}
