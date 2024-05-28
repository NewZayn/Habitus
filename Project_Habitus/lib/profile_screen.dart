import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_picture.png'), // Adicione sua imagem em assets
            ),
            SizedBox(height: 20),
            Text(
              'Nome do Usuário',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'email@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Número de Telefone'),
              subtitle: Text('+55 12 34567-8901'),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Endereço'),
              subtitle: Text('Rua Exemplo, 123, Cidade, Estado'),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Data de Nascimento'),
              subtitle: Text('01/01/1990'),
            ),
          ],
        ),
      ),
    );
  }
}
