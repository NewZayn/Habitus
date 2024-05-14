


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';



class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  String _difference = '';
  var maskFormatter = new MaskTextInputFormatter(mask: '##/##/####', filter: { "#": RegExp(r'[0-9]') });

  get mainAxisAlignment => null;

  void _calculateDifference() {
    DateTime date1 = _parseDate(_controller1.text);
    DateTime date2 = _parseDate(_controller2.text);

    if (date2.isBefore(date1)) {
      setState(() {
        _difference = 'A data de cima não pode ser menor que a de baixo';
      });
    } else {
      int difference = date2.difference(date1).inDays;
      setState(() {
        _difference = 'Diferença: $difference dias';
      });
    }
  }

  DateTime _parseDate(String date) {
    List<String> dateParts = date.split('/');
    return DateTime(int.parse(dateParts[2]), int.parse(dateParts[1]), int.parse(dateParts[0]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.cyanAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: "Logout",
          )
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.inversePrimary,
        padding: const EdgeInsets.all(10),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                width: 400,
                child: Row(
                    children: <Widget> [
                      Text("Contador de Dias",
                      style: TextStyle(
                        fontSize: 20,
                       )
                      ),
                    ]
                ),
              ),
            ),
            Text("Data Inicial"),
            TextFormField(
              inputFormatters: [maskFormatter],
              controller: _controller1,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: 'Digite a primeira data (dd/mm/yyyy)',
                labelStyle: CupertinoTextField.cupertinoMisspelledTextStyle,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text("Data Final"),
            TextFormField(
              inputFormatters: [maskFormatter],
              controller: _controller2,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: 'Digite a segunda data (dd/mm/yyyy)',
                labelStyle: CupertinoTextField.cupertinoMisspelledTextStyle,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 60,
              width: 400,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_difference)
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 60,
              width: 400,
              child: CupertinoButton(
                onPressed: _calculateDifference,
                child: Text('Calcular diferença'),
                borderRadius: BorderRadius.circular(10),
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
  _logout() {
    FirebaseAuth.instance.signOut().then((result) {
      Navigator.of(context).pushNamedAndRemoveUntil("/login", (_) => false);
    });
  }
}
