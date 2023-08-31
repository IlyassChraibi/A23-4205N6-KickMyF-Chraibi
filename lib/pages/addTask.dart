import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../dto/lib_http.dart';
import '../dto/transfer.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  final TextEditingController taskNameController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  void addTask() async {
    try {

      AddTaskRequest addTaskRequest = AddTaskRequest(taskNameController.text, selectedDate,);


      var response = await SingletonDio.getDio().post(
          'http://10.0.2.2:8080/api/add',
          data: addTaskRequest.toJson());
      print(response);

      Navigator.pop(context);
    } on DioError catch (e) {
      final snackBar = SnackBar(
        content: Text(e.response?.data),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        // Set the selected date with only the date portion (no time)
        selectedDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: taskNameController,
                decoration: const InputDecoration(labelText: 'Task Name'),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Due Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: addTask,
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}