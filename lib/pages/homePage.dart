import 'package:flutter/material.dart';
import 'package:kickmyf/pages/DetailPage.dart';
import 'package:kickmyf/pages/addTask.dart';
import 'task.dart';
import 'package:intl/intl.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    generateTasks();
  }

  void generateTasks() {
    for (int i = 1; i <= 7; i++) {
      tasks.add(
        Task(
          name: 'Tâche $i',
          progress: 20 + i * 10,
          timeElapsed: i * 5,
          dueDate: DateTime.now().add(Duration(days: i * 2)),
        ),
      );
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
                        MaterialPageRoute(builder: (context) =>  DetailPage()),
                      );
                    },
                    title: Text(task.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Progress: ${task.progress}%'),
                            CircularProgressIndicator(
                              value: task.progress / 100,
                              backgroundColor: Colors.grey,
                              color: Colors.blue,
                              strokeWidth: 4,
                            ),
                          ],
                        ),
                        Text('Time Elapsed: ${task.timeElapsed}%'),
                        Text('Due Date: ${DateFormat('yyyy-MM-dd HH:mm').format(task.dueDate)}'),
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
                        builder: (context) => AddPage()
                    ),
                  );
                },
                child: Text('Add Task'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Change the button color
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
