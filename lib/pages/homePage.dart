import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:kickmyf/components/my_button.dart';
import 'package:kickmyf/components/my_textfield.dart';

import '../dto/SessionSingleton.dart';
import '../dto/lib_http.dart';
import '../dto/transfer.dart';

class HomePage extends StatefulWidget {
  @override
  _EcranCState createState() => _EcranCState();
}

//https://kickmyb-server.herokuapp.com/
//localhost:8080/api/id/signup
//10.0.2.2

class _EcranCState extends State<HomePage> {

  void home() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ecran C'),
        backgroundColor: Colors.black,
      ),
      body: Center(

      ),
    );
  }
}
