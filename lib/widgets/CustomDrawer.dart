import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../dto/SessionSingleton.dart';
import '../dto/lib_http.dart';
import '../pages/addTask.dart';
import '../pages/homePage.dart';
import '../pages/loginPage.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xff764abc)),
            child: Text(
              SessionSingleton.shared.username!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
            ),
            title: const Text('Accueil'),
            onTap: ()  {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            }
          ),
          ListTile(
              leading: const Icon(
                Icons.add,
              ),
              title: const Text('Ajout de tâche'),
              onTap: ()  {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AddPage()),
                );
              }
          ),

          ListTile(
            leading: const Icon(
              Icons.logout,
            ),
            title: const Text('Logout'),
            onTap: () async {
              try {
                //On envoie la request  avec l'object creer au SERVEUR
                var response = await SingletonDio.getDio().post(
                  'http://10.0.2.2:8080/api/id/signout',
                );

                //Remove le username dans le singleton pour simuler une "session" inactive
                SessionSingleton.shared.username = null;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              } on DioError catch (e) {
                //gerer l'erreur avec un snack bar??

                final snackBar = SnackBar(
                  content: Text(e.response?.data),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          ),
        ],
      ),
    );
  }
}
