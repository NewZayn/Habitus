import 'dart:async';
import 'package:flutter/material.dart';
import 'package:newapp/back4app/services/loginservice.dart';
import 'package:newapp/templates/login.dart';
import 'package:newapp/templates/home.dart';
import 'package:newapp/templates/register.dart';

import 'back4app/services/registerservice.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  RegisterService registerService = RegisterService();
  await registerService.initialize();
  runApp(const MyApp());
}

const mainColor = Color(0xFF4672ff);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habitus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(mainColor),
            minimumSize: MaterialStateProperty.all(
              const Size.fromHeight(60),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage()
        // Other routes can be defined here
      },
    );
  }
}
