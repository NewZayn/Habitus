import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newapp/back4app/services/registerservice.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerEmail = TextEditingController();
  final RegisterService _registerService = RegisterService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter SignUp'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 200,
                child: Image.asset(
                    "assets/icons/img.png"),
              ),
              const Center(
                child: Text('Habitus',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue)),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text('Sign Up',
                    style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controllerUsername,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  labelText: 'Username',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controllerEmail,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  labelText: 'E-mail',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controllerPassword,
                obscureText: true,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 50,
                child: TextButton(
                  onPressed: () => doUserRegistration(),
                  child: const Text('Sign Up', style: TextStyle(color: Colors.blue)),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSuccess() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: const Text("User was successfully created!"),
          actions: <Widget>[
            CupertinoButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            CupertinoButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void doUserRegistration() async {
    final username = controllerUsername.text.trim();
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      showError("All fields are required.");
      return;
    }
    try {
      final user = await _registerService.registerUser(username, password, email);
      showSuccess();
    } catch (e) {
      showError(e.toString());
    }
  }
}
