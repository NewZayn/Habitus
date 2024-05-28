import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/components/categorybutton.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Home', style: TextStyle(color: Colors.transparent)),
        elevation: 0,
        toolbarHeight: 0, // Hidden AppBar title
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CategoryButton("Home"),
                CategoryButton("Exercícios"),
                CategoryButton("Estudo"),
                CategoryButton("Trabalho"),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hoje',
                    style: TextStyle(fontSize: 24.0),
                  ),
                  Spacer(),
                  FloatingActionButton.extended(
                    onPressed: () {
                      // Add habit creation logic here
                    },
                    label: Text('Clique aqui para criar um hábito'),
                    icon: Icon(Icons.add),
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'Hábitos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendário',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
      ),
    );
  }

  _logout() {
    FirebaseAuth.instance.signOut().then((result) {
      Navigator.of(context).pushNamedAndRemoveUntil("/login", (_) => false);
    });
  }
}
