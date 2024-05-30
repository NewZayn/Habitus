import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:newapp/back4app/services/loginservice.dart'; // Import LoginService
import 'package:newapp/back4app/services/userservice.dart'; // Import UserService
import 'login.dart';
import 'editprofile.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final UserService userService = UserService();
  final LoginService loginService = LoginService();

  Future<void> _logout(BuildContext context) async {
    try {
      await loginService.logoutUser();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      // Handle logout error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao fazer logout: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<ParseUser?>(
        future: userService.getCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<ParseUser?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Nenhum usuário logado'));
          } else {
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Nome: ${user.username ?? 'Não disponível'}',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Email: ${user.emailAddress ?? 'Não disponível'}',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      bool? updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditProfilePage()),
                      );
                      if (updated == true) {
                        // Refresh the profile page to show updated information
                        (context as Element).reassemble();
                      }
                    },
                    child: const Text('Editar Perfil'),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      await _logout(context);
                    },
                    style: ElevatedButton.styleFrom(
                      iconColor: Colors.red,
                    ),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
