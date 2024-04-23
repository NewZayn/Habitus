import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

final keyApplicationId = 'dA9iQuXlEF700vefoWI7nwCHALI133HU5Utkbdaf';
final keyClientKey = 'tPMQ2K87ulZZl049jDp0e5FjSr8WKEsBVhCj3OUA';
final keyParseServerUrl = 'https://parseapi.back4app.com';

void main() async {
  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  var firstObject = ParseObject('FirstClass')
    ..set(
        'message', 'Hey ! First message from Flutter. Parse is now connected');
  await firstObject.save();

  print('done');
}
