import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kickmyf/pages/DetailPage.dart';
import 'package:kickmyf/pages/addTask.dart';
import '../dto/lib_http.dart';
import '../dto/transfer.dart';
import 'package:intl/intl.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<HomeItemResponse> tasks = [];

  @override
  void initState() {
    super.initState();
    generateTasks();
  }

  Future<void> generateTasks() async {
    try {
      var response = await SingletonDio.getDio().get(
          'http://10.0.2.2:8080/api/home');

//for
      var res = response.data as List;
      var Taches = res.map(
              (elementJSON) {
            return HomeItemResponse.fromJson(elementJSON);
          }
      ).toList();

      tasks = Taches;

      setState(() {});

    }
    on DioError catch (e) {
      {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Erreur reseau')
            )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  DetailPage( taskId: tasks[index].id,)),
                      );
                    },
                    title: Text(task.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Progress: ${task.percentageDone}%'),
                            CircularProgressIndicator(
                              value: task.percentageDone / 100,
                              backgroundColor: Colors.grey,
                              color: Colors.blue,
                              strokeWidth: 4,
                            ),
                          ],
                        ),
                        Text('Time Elapsed: ${task.percentageTimeSpent}%'),
                        Text('Due Date: ${DateFormat('yyyy-MM-dd HH:mm').format(task.deadline)}'),
                      ],
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
                        builder: (context) => const AddPage()
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Change the button color
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Add Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
