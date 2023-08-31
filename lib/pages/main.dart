import 'package:flutter/material.dart';
import 'package:kickmyf/pages/DetailPage.dart';
import 'package:kickmyf/pages/addTask.dart';
import 'package:kickmyf/pages/homePage.dart';
import 'package:kickmyf/pages/loginPage.dart';
import 'package:kickmyf/pages/signupPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: LoginPage(),
      routes: routes(),
    );
  }
  Map<String, WidgetBuilder> routes() {
    return {
      '/ecrana': (context) => LoginPage(),
      '/ecranb': (context) => SignupPage(),
      '/ecranc': (context) => HomePage(),
      '/ecrand': (context) => AddPage(),
      '/ecrane': (context) => DetailPage(),
    };
  }
}

