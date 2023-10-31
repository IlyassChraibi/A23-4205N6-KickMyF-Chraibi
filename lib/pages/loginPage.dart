import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:kickmyf/components/my_button.dart';
import 'package:kickmyf/components/my_textfield.dart';
import 'package:kickmyf/pages/signupPage.dart';

import '../dto/SessionSingleton.dart';
import '../dto/lib_http.dart';
import '../dto/transfer.dart';
import '../i18n/intl_localization.dart';
import 'homePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _EcranAState createState() => _EcranAState();
}


class _EcranAState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isProcessing = false;

  void signIn() async {

    if (isProcessing) {
      return; // Empêcher les actions multiples pendant le traitement
    }

    setState(() {
      isProcessing = true; // Activer l'indicateur d'attente et désactiver les boutons
    });

    //On creer la signIn objet qui contient username
    SignupRequest signinResponse = SignupRequest(usernameController.text, passwordController.text);

    try {
      var response = await SingletonDio.getDio().post(
        'https://kickmybfree.azurewebsites.net/api/id/signin',
        data: signinResponse.toJson(),
      );

      SigninResponse signInResponse = SigninResponse.fromJson(response.data);
      SessionSingleton.shared.username = signInResponse.username;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on DioError catch (e) {
      final snackBar = SnackBar(
        content: Text(e.response?.data),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } finally {
      setState(() {
        isProcessing = false; // Désactiver l'indicateur d'attente
      });
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
               Text(
                Locs.of(context).trans('signup_welcome'),
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: usernameController,
                hintText:  Locs.of(context).trans('signup_username'),
                obscureText: false,
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: passwordController,
                hintText:  Locs.of(context).trans('signup_password'),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              isProcessing
                  ? CircularProgressIndicator() // Indicateur d'attente
                  : MyButton(
                onPressed: signIn,
                btnName: Locs.of(context).trans('signinbutton'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                  Locs.of(context).trans('signin_member'),
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 4),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupPage(),
                        ),
                      );
                    },
                    child: Text(
                      Locs.of(context).trans('signin_register'),
                      style: const TextStyle(
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
