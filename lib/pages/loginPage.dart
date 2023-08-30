import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:kickmyf/components/my_button.dart';
import 'package:kickmyf/components/my_textfield.dart';

import '../dto/SessionSingleton.dart';
import '../dto/lib_http.dart';
import '../dto/transfer.dart';

class LoginPage extends StatefulWidget {
  @override
  _EcranAState createState() => _EcranAState();
}

//https://kickmyb-server.herokuapp.com/
//localhost:8080/api/id/signup

class _EcranAState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signIn() async {
    //On creer la signIn objet qui contient username
    SignupRequest signinRequest = SignupRequest(usernameController.text, passwordController.text);

    try {
      //On envoie la request  avec l'object creer au SERVEUR
      var response = await SingletonDio.getDio().post(
          //'https://kickmyb-server.herokuapp.com/api/id/signin',
          'https://localhost:8080/api/id/signin',
          data: signinRequest.toJson());

      //Le serveur nous envois une reponse de type SignInResponse (qui contient seulement un username...)
      //Il est important de MAPPER le response.data TO SigninResponse
      SigninResponse signInResponse = SigninResponse.fromJson(response.data);

      //Sauvegarder le username dans le singleton pour simuler une "session" active
      SessionSingleton.shared.username = signInResponse.username;

      print(response);

      //Navigator.pushReplacement(
        //context,
        //MaterialPageRoute(builder: (context) =>  HomeScreen()),
     // );

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
              const SizedBox(height: 30),
              MyButton(
                onPressed: signIn,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Not a member?',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 4),
                  TextButton(
                    onPressed: () {
                      // Logique pour l'inscription
                    },
                    child: const Text(
                      'Register Now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
