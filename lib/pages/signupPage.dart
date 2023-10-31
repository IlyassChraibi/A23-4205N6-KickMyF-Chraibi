import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:kickmyf/components/my_button.dart';
import 'package:kickmyf/components/my_textfield.dart';

import '../dto/SessionSingleton.dart';
import '../dto/lib_http.dart';
import '../dto/transfer.dart';
import 'homePage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _EcranBState createState() => _EcranBState();
}

class _EcranBState extends State<SignupPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String isEqual = ''; // Utilisez une chaîne vide pour l'inégalité des mots de passe
  bool isProcessing = false; // Indicateur pour le traitement en cours
  String errorMessage = ''; // Message d'erreur

  String getErrorMessageFromResponse(String errorMessage) {
    switch (errorMessage) {
      case 'UsernameAlreadyTaken':
        return 'Le nom d\'utilisateur est déjà pris.';
    // Ajoutez d'autres cas pour d'autres messages d'erreur si nécessaire
    case 'Les mots de passe ne correspondent pas':
    return 'Les mots de passe ne correspondent pas';
      default:
        return 'Une erreur s\'est produite. Vérifier Réseau';
    }
  }


  void signUp() async {
    if (isProcessing) {
      return; // Empêcher les actions multiples pendant le traitement
    }

    setState(() {
      isProcessing = true; // Activer l'indicateur d'attente et désactiver les boutons
      errorMessage = ''; // Réinitialiser le message d'erreur
    });

    if (passwordController.text == confirmPasswordController.text) {
      isEqual = passwordController.text;
    } else {
      setState(() {
        isProcessing = false; // Désactiver l'indicateur d'attente
        errorMessage = "Les mots de passe ne correspondent pas";
      });
      return; // Sortie de la fonction en cas de non-correspondance des mots de passe
    }

    SignupRequest signupRequest = SignupRequest(usernameController.text, isEqual);

    try {
      var response = await SingletonDio.getDio().post(
        'https://kickmybfree.azurewebsites.net/api/id/signup',
        data: signupRequest.toJson(),
      );

      // Le traitement a réussi

      setState(() {
        isProcessing = false; // Désactiver l'indicateur d'attente
        errorMessage = ''; // Réinitialiser le message d'erreur
      });

      SigninResponse signUpResponse = SigninResponse.fromJson(response.data);
      SessionSingleton.shared.username = signUpResponse.username;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on DioError catch (e) {
      // Le traitement a échoué

      setState(() {
        isProcessing = false; // Désactiver l'indicateur d'attente
        errorMessage = e.response?.data.toString() ?? "Une erreur s'est produite.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SingleChildScrollView(
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
                  const SizedBox(height: 20),
                  if (errorMessage.isNotEmpty)
                    Text(
                      getErrorMessageFromResponse(errorMessage),
                      style: TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 100),
                  isProcessing
                      ? CircularProgressIndicator() // Indicateur d'attente
                      : MyButton(
                    onPressed: signUp,
                    btnName: "signUp",
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


