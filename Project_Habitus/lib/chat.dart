import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

final keyApplicationId = 'dA9iQuXlEF700vefoWI7nwCHALI133HU5Utkbdaf';
final keyClientKey = 'tPMQ2K87ulZZl049jDp0e5FjSr8WKEsBVhCj3OUA';
final keyParseServerUrl = 'https://parseapi.back4app.com';

class Chat {
  static Future<void> initParse(String h) async {
    await Parse().initialize(keyApplicationId, keyParseServerUrl,
        clientKey: keyClientKey, autoSendSessionId: true);

    var todo = ParseObject('todo')..set('chat', h);
    await todo.save();
  }
}
