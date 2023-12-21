import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'dto/transfer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Examen App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController val1Controller = TextEditingController();
  final TextEditingController val2Controller = TextEditingController();

  final Dio dio = Dio();

  void _sendRequest() async {
    String val1 = val1Controller.text;
    String val2 = val2Controller.text;

    if (val1.isEmpty || val2.isEmpty) {
      _showErrorSnackbar("Veuillez remplir les deux champs.");
      return;
    }

    try {
      int.parse(val1);
      int.parse(val2);
    } catch (e) {
      _showErrorSnackbar("Les deux valeurs doivent être des nombres entiers.");
      return;
    }

    final url = "http://10.0.2.2:8080/examen/plusgrand/";
    final body = {"val1": val1.toString(), "val2": val2.toString()};

    try {
      final response = await dio.post(
        url,
        data: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Check if the response is an integer
        if (response.data is int) {
          _showSuccessSnackbar("La plus grande des 2 valeurs est ${response.data}");
        } else {
          _showErrorSnackbar("Erreur: Format de réponse inattendu.");
        }
      } else {
        _showErrorSnackbar("Les deux valeurs sont égales.");
      }
    } catch (e) {
      _showErrorSnackbar("Les deux valeurs sont égales.");

    }
  }


  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Examen App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: val1Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Valeur 1'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: val2Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Valeur 2'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendRequest,
              child: Text('Envoyer la requête'),
            ),
          ],
        ),
      ),
    );
  }
}
