import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:kickmyf/components/my_button.dart';
import 'package:kickmyf/components/my_textfield.dart';

import '../dto/SessionSingleton.dart';
import '../dto/lib_http.dart';
import '../dto/transfer.dart';

class SignupPage extends StatefulWidget {
  @override
  _EcranBState createState() => _EcranBState();
}

//https://kickmyb-server.herokuapp.com/
//localhost:8080/api/id/signup
//10.0.2.2

class _EcranBState extends State<SignupPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  late String isEqual;

  void signUp() async {

    if(passwordController.text == confirmPasswordController.text){
      isEqual=passwordController.text;
    }
    SignupRequest signupRequest = SignupRequest(usernameController.text, isEqual);

    try {
      var response = await SingletonDio.getDio().post(
          'http://10.0.2.2:8080/api/id/signup',
          data: signupRequest.toJson());

      SigninResponse signInResponse = SigninResponse.fromJson(response.data);

      SessionSingleton.shared.username = signInResponse.username;

      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  HomeScreen()),
      );*/

    } on DioError catch (e) {
      //gerer l'erreur avec un snack bar??

      final  snackBar = SnackBar(
        content: Text(e.response?.data),
      );
      // Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              const Icon(
                Icons.safety_divider,
                size: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome back !',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm password',
                obscureText: true,
              ),
              const SizedBox(height: 100),
              MyButton(
                onPressed: signUp,
                btnName: "signUp",
              ),
              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}
