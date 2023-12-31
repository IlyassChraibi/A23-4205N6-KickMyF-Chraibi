import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kickmyf/pages/DetailPage.dart';
import 'package:kickmyf/pages/addTask.dart';
import '../dto/lib_http.dart';
import '../dto/transfer.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../i18n/intl_localization.dart';
import '../widgets/CustomDrawer.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<HomeItemPhotoResponse> tasks = [];
  bool isFetchingData = false; // Indicateur pour le chargement des données

  @override
  void initState() {
    super.initState();
    generateTasks();
  }


  Future<void> generateTasks() async {
    if (isFetchingData) {
      return; // Empêcher les actions multiples pendant le chargement
    }

    setState(() {
      isFetchingData = true; // Activer l'indicateur d'attente
    });

    try {
      var response = await SingletonDio.getDio().get('https://kickmybfree.azurewebsites.net/api/home/photo');

      var res = response.data as List;
      var Taches = res.map((elementJSON) {
        return HomeItemPhotoResponse.fromJson(elementJSON);
      }).toList();

      tasks = Taches;

      setState(() {});
    } on DioError catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Locs.of(context).trans('home_error')),
          action: SnackBarAction(
            label: Locs.of(context).trans('home_reload'),
            onPressed: () {
              generateTasks(); // Rechargez les données lorsque l'utilisateur appuie sur le bouton de rechargement
            },
          ),
        ),
      );
    } finally {
      setState(() {
        isFetchingData = false; // Désactiver l'indicateur d'attente
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Locs.of(context).trans('home_list')),
        backgroundColor: Colors.black,
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: isFetchingData
                  ? Center(child: CircularProgressIndicator()) // Indicateur d'attente
                  : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {

                  final task = tasks[index];
                  final imageId = task.photoId; // Récupérez l'ID de l'image de la tâche
                  final imageNetworkPath = 'https://kickmybfree.azurewebsites.net/file/$imageId'; // Créez l'URL de l'image
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(taskId: tasks[index].id),
                        ),
                      );
                    },
                    title: Text(task.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${Locs.of(context).trans('home_progress')}: ${task.percentageDone}%"),
                            CircularProgressIndicator(
                              value: task.percentageDone / 100,
                              backgroundColor: Colors.grey,
                              color: Colors.blue,
                              strokeWidth: 4,
                            ),
                          ],
                        ),
                        Text('${Locs.of(context).trans('home_time')}: ${task.percentageTimeSpent}%'),
                        Text('${Locs.of(context).trans('home_date')}: ${DateFormat('yyyy-MM-dd HH:mm').format(task.deadline)}'),
                      ],
                    ),
                    leading: (imageId == null || imageId == 0) // Vérifiez si l'ID de l'image est valide
                        ? null
                        : Image.network(
                      imageNetworkPath, // Utilisez l'URL de l'image spécifique à la tâche
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: Text(Locs.of(context).trans('home_add')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

