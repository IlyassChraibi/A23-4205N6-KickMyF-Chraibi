import 'package:flutter/material.dart';
import 'package:kickmyf/components/my_textfield.dart';

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
        title: Text(widget.title),
      ),
      backgroundColor: Colors.grey[300],
      body: const Center(
        child: Column(
        children: [

           SizedBox(height: 50),
          //logo
          Icon(
            Icons.safety_divider,
            size: 100
          ),

          //welcome text
          SizedBox(height: 50),
          Text(
            'Welcome back !',
            style: TextStyle(color: Colors.grey),
          ),

          //username
          SizedBox(height: 25),
         MyTextField(),

          //password
          SizedBox(height: 25),
          MyTextField(),

          //sigin button

          //not a member? register now
        ],

        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
