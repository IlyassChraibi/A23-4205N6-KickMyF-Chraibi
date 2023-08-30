import 'package:flutter/material.dart';
import 'package:kickmyf/components/my_button.dart';
import 'package:kickmyf/components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  @override
  _EcranAState createState() => _EcranAState();
}

class _EcranAState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signUserIn() {
    // Logique pour connecter l'utilisateur
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
                onPressed: signUserIn,
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
