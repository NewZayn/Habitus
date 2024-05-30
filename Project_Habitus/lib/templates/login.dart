
import 'package:flutter/material.dart';
import '../back4app/services/loginservice.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  bool isLoggedIn = false;
  final loginService = LoginService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                    "assets/icons/img.png" ),
              ),
              const Center(
                child: Text('Habitus',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue)),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text('Bem-vindo!',
                    style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controllerUsername,
                enabled: !isLoggedIn,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    labelText: 'Username'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controllerPassword,
                enabled: !isLoggedIn,
                obscureText: true,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    labelText: 'Password'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: TextButton(
                  onPressed: isLoggedIn ? null : () => doUserLogin(),
                    child: const Text('Login', style: TextStyle(color: Colors.blue)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                      child: const Text('Sign Up', style: TextStyle(color: Colors.blue)),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  void showSuccess(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
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
            TextButton(
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

  void doUserLogin() async {
    final username = controllerUsername.text.trim();
    final password = controllerPassword.text.trim();

    if (username.isEmpty || password.isEmpty) {
      showError("All fields are required.");
      return;
    }
    try {
      final user = await loginService.loginUser(username, password);
      setState(() {
        isLoggedIn = true;
      });
      showSuccess("User logged in successfully!");
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
    } catch (e) {
      showError(e.toString());
    }
  }

  void doUserLogout() async {
    try {
      await loginService.logoutUser();
      setState(() {
        isLoggedIn = false;
      });
      showSuccess("User logged out successfully!");

    } catch (e) {
      showError(e.toString());
    }
  }
}
