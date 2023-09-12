import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../dto/lib_http.dart';
import '../dto/transfer.dart';

class DetailPage extends StatefulWidget {
  final int taskId;

  const DetailPage({Key? key, required this.taskId}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late HomeItemResponse taskDetail = new HomeItemResponse(0, "", DateTime.now(), 0, 0);

  @override
  void initState() {
    super.initState();
    getTaskDetail();
  }

  Future<void> getTaskDetail() async {
    try {
      var response = await SingletonDio.getDio().get(
        'http://10.0.2.2:8080/api/detail/${widget.taskId}', // Utilisez l'ID de la tâche ici
      );

      setState(() {
        taskDetail = HomeItemResponse.fromJson(response.data);
      });
    } on DioError catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur réseau'),
        ),
      );
    }
  }
  void updateProgress(int taskId, int newProgress) async {
    try {
      var response = await SingletonDio.getDio().get(
        'http://10.0.2.2:8080/api/progress/$taskId/$newProgress', // Utilisez l'ID de la tâche ici
      );

      setState(() {
        taskDetail = HomeItemResponse.fromJson(response.data);
      });
    } on DioError catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur réseau'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la Tâche'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${taskDetail.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Date d\'échéance : ${ DateFormat('dd MMMM yyyy').format(taskDetail.deadline)}',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'Pourcentage d\'avancement : ${taskDetail.percentageDone}%',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'Pourcentage de temps écoulé : ${taskDetail.percentageTimeSpent}%',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),





            ElevatedButton(
              onPressed: () {
                // Ouvrir un dialogue pour modifier le pourcentage d'avancement
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Modifier le Pourcentage d\'Avancement'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Nouveau pourcentage :'),
                          Slider(
                            value: taskDetail.percentageDone.toDouble(),
                            onChanged: (value) {
                              setState(() {
                                taskDetail.percentageDone = value.toInt();
                              });
                            },
                            min: 0,
                            max: 100,
                            divisions: 10,
                          ),
                          Text('${taskDetail.percentageDone} %'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Annuler'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Envoyer la nouvelle valeur du pourcentage au serveur
                            updateProgress(widget.taskId, taskDetail.percentageDone);
                            // Après la mise à jour, fermez la boîte de dialogue
                            Navigator.of(context).pop();
                          },
                          child: const Text('Enregistrer'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Modifier le Pourcentage d\'Avancement'),
            ),




          ],
        ),
      ),
    );
  }
}
