import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = 'NU1Maj9YTgz3o9Olc68JdTQeRgcXMQU34MwOuN0A';
  final keyClientKey = 'zHYbZineM76UmaPJdlH0BKEogfl8CVahj8ydAE76';
  final keyParseServerUrl = 'https://parseapi.back4app.com';
  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  var user = ParseObject("Todo")..set("description", "ronaldo");
  await user.save();
}
