import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertraductiona22/i18n/intl_delegate.dart';
import 'package:fluttertraductiona22/i18n/intl_localizaton.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DemoDelegate(),
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('fr', ''),
        // Add other locales as needed
      ],
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align the first container to the left
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 4 / 5,
            color: Colors.blue, // Blue container
            padding: EdgeInsets.all(16), // Optional: Add padding for better visual
            child: Text(
              Locs.of(context).trans('macsarelife'),
              style: TextStyle(color: Colors.white),
            ),
          ), // Optional: Add spacing between the first and second containers
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 4 / 5,
              color: Colors.green, // Green container
              padding: EdgeInsets.all(16), // Optional: Add padding for better visual
              child: Text(
                Locs.of(context).trans('macsarelife'),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                color: Colors.purple, // Adjust color as needed
                padding: EdgeInsets.all(16), // Optional: Add padding for better visual
                child: Text(
                  Locs.of(context).trans('macsarelife'),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),




      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
