import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int reponse = -1;
  int userGuess = 0;
  String resultMessage = '';

  void getHttp() async {
    try {
      var response =
      await Dio().get('https://4n6.azurewebsites.net/exos/long/double/99');
      print(response);
      reponse = response.data;
      setState(() {
        resultMessage = ''; // Réinitialise le message après chaque requête
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Erreur réseau')));
    }
  }

  void compareNumbers() {
    if (userGuess == 0) {
      setState(() {
        resultMessage = 'Veuillez entrer un nombre.';
      });
    } else {
      if (userGuess == reponse) {
        setState(() {
          resultMessage = 'Félicitations! Vous avez deviné le bon nombre!';
        });
      } else if (userGuess < reponse) {
        setState(() {
          resultMessage = 'Le nombre que vous avez entré est trop bas.';
        });
      } else {
        setState(() {
          resultMessage = 'Le nombre que vous avez entré est trop élevé.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Le nombre est $reponse',
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                try {
                  userGuess = int.parse(value);
                } catch (e) {
                  userGuess = 0; // Réinitialise à 0 si la conversion échoue
                }
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Entrez un nombre',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: compareNumbers,
              child: Text('Comparer'),
            ),
            SizedBox(height: 20),
            Text(
              resultMessage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getHttp,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
