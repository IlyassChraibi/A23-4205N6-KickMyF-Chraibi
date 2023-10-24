import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kickmyf/pages/homePage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../dto/lib_http.dart';
import '../dto/transfer.dart';
import '../widgets/CustomDrawer.dart';

class DetailPage extends StatefulWidget {
  final int taskId;

  const DetailPage({Key? key, required this.taskId}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  //late HomeItemResponse taskDetail = new HomeItemResponse(0, "", DateTime.now(), 0, 0);

  late TaskDetailPhotoResponse taskDetailPhoto = new TaskDetailPhotoResponse(0, "", DateTime.now(), 0, 0,0);
  late TextEditingController percentageController;
  bool isImageUploading = false;

  String imageNetworkPath = "";
  String imagePath = "";
  XFile? pickedImage;
  ImagePicker image = ImagePicker();


  @override
  void initState() {
    super.initState();
    getTaskDetailPhoto();
    percentageController = TextEditingController();
  }


  Future<void> getTaskDetailPhoto() async {
    try {
      setState(() {
        isImageUploading = true; // Démarrez l'indicateur de chargement
      });

      var response = await SingletonDio.getDio().get(
        'http://10.0.2.2:8080/api/detail/photo/${widget.taskId}',
      );
      print(response);

      setState(() {
        taskDetailPhoto = TaskDetailPhotoResponse.fromJson(response.data);
        imageNetworkPath = 'http://10.0.2.2:8080/file/'+ taskDetailPhoto.photoId.toString();
        isImageUploading = false;
      });
    } on DioError catch (e) {
      setState(() {
        isImageUploading = false; // Assurez-vous d'arrêter l'indicateur en cas d'erreur
      });
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur réseau'),
        ),
      );
    }
  }
  Future<void> updateProgress(int taskId, int newProgress) async {
    try {
      var response = await SingletonDio.getDio().get(
        'http://10.0.2.2:8080/api/progress/$taskId/$newProgress', // Utilisez l'ID de la tâche ici
      );
    } on DioError catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur réseau'),
        ),
      );
    }
  }


  Future<void> sendImage() async {
    try {
      setState(() {
        isImageUploading = true; // Démarrer l'indicateur d'attente
      });

      pickedImage = await image.pickImage(source: ImageSource.gallery);
      imagePath = pickedImage!.path;
      if (pickedImage != null) {
        FormData formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(pickedImage!.path, filename: pickedImage!.name),
          'taskID': widget.taskId.toString(),
        });

        var response = await SingletonDio.getDio().post(
          'http://10.0.2.2:8080/file',
          data: formData,
        );
        String id = response.data as String;

        imageNetworkPath = 'http://10.0.2.2:8080/file/'+ id;


        setState(() {
          isImageUploading = false; // Arrêter l'indicateur d'attente
        });
      }
    } on DioError catch (e) {
      print(e);

      setState(() {
        isImageUploading = false; // Assurez-vous d'arrêter l'indicateur en cas d'erreur
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur réseau lors de l\'envoi de l\'image.'),
        ),
      );
    }
  }




  @override
  void dispose() {
    percentageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la Tâche'),
        backgroundColor: Colors.black,
      ),
      drawer: CustomDrawer(),
      body: Center(
        child : SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${taskDetailPhoto.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Date d\'échéance : ${DateFormat('dd MMMM yyyy').format(taskDetailPhoto.deadline)}',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'Pourcentage d\'avancement : ${taskDetailPhoto.percentageDone}%',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'Pourcentage de temps écoulé : ${taskDetailPhoto.percentageTimeSpent}%',
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
                          TextField(
                            controller: percentageController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Entrez le pourcentage',
                            ),
                          ),
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
                          onPressed: () async {
                            // Envoyer la nouvelle valeur du pourcentage au serveur
                            final newPercentage = int.tryParse(percentageController.text);
                            if (newPercentage != null && newPercentage >= 0 && newPercentage <= 100) {
                              await updateProgress(widget.taskId, newPercentage);
                              // Après la mise à jour, fermez la boîte de dialogue
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => HomePage()),
                              );
                            } else {
                              // Afficher une erreur si le pourcentage est invalide
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Pourcentage invalide. Veuillez entrer un nombre entre 0 et 100.'),
                                ),
                              );
                            }
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

            (imagePath.isEmpty)
                ? Container(
              width: 200, // Largeur souhaitée
              height: 200, // Hauteur souhaitée
              child: Center(
                child: Text("Sélectionner une image"),
              ),
            )
                : Container(
              width: 200, // Largeur souhaitée
              height: 200, // Hauteur souhaitée
              child: Image.file(
                File(imagePath),
                width: 200, // Ajustez la taille de l'image ici
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            ElevatedButton(
              onPressed: isImageUploading ? null : () {
                sendImage(); // Appeler la fonction pour envoyer une image
              },
              child: isImageUploading
                  ? CircularProgressIndicator() // Afficher l'indicateur d'attente pendant l'envoi
                  : const Text('Envoyer une Image'),
            ),
            (isImageUploading)
                ? CircularProgressIndicator() // Afficher l'indicateur de chargement
                : (imageNetworkPath.isEmpty)
                ? Text("Image non trouvée")
                : Container(
              width: 200, // Largeur souhaitée
              height: 200, // Hauteur souhaitée
              child: Image.network(
                imageNetworkPath,
                width: 200, // Ajustez la taille de l'image ici
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
