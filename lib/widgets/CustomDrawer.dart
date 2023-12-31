import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../dto/SessionSingleton.dart';
import '../dto/lib_http.dart';
import '../i18n/intl_localization.dart';
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
            title: Text(Locs.of(context).trans('drawer_home')),
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
              title: Text(Locs.of(context).trans('drawer_add')),
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
            title: Text(Locs.of(context).trans('drawer_logout')),
            onTap: () async {
              try {
                //On envoie la request  avec l'object creer au SERVEUR
                var response = await SingletonDio.getDio().post(
                  'https://kickmybfree.azurewebsites.net/api/id/signout',
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
