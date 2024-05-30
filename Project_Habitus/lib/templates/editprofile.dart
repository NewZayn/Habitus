import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:newapp/back4app/services/userservice.dart'; // Import UserService

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  final UserService userService = UserService();

  Future<void> _getCurrentUserDetails() async {
    final user = await userService.getCurrentUser();
    if (user != null) {
      setState(() {
        _usernameController.text = user.username ?? '';
        _emailController.text = user.emailAddress ?? '';
      });
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await userService.updateUser(
          _usernameController.text, _emailController.text);
      Navigator.pop(context, true);
    } catch (e) {
      // Handle update error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao atualizar o perfil: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _usernameController,
                    decoration:
                        const InputDecoration(labelText: 'Nome de Usuário'),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: const Text('Salvar Alterações'),
                  ),
                ],
              ),
            ),
    );
  }
}
