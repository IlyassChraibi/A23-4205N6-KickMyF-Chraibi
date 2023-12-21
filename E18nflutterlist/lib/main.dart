import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertraductiona22/i18n/intl_delegate.dart';
import 'package:fluttertraductiona22/i18n/intl_localizaton.dart';

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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DemoDelegate(),
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('fr', ''),
        // Add other locales as needed
      ],
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
        title: Text(Locs.of(context).trans('macsarelife')),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width / 3,
            child: Image.network(
              'https://example.com/your_image_url.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Action du premier bouton
                  },
                  child: Text(Locs.of(context).trans('macsarelife')),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Action du deuxième bouton
                  },
                  child: Text(Locs.of(context).trans('macsarelife')),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildListItem(context, 'junuary', Icons.star), // Utilisez la clé correcte
              // Ajoutez d'autres éléments de liste au besoin
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildListItem(BuildContext context, String itemNameKey, IconData icon) {
    return ListTile(
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          Locs.of(context).trans(itemNameKey), // Utilisez la clé correcte pour le nom de l'élément de la liste
          style: TextStyle(fontSize: 16),
        ),
      ),
      trailing: Icon(icon),
    );
  }


}
