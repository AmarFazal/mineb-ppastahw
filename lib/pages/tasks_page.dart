import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:whatsapp_agent_android/widgets/snackbar.dart';
import 'dart:convert';
import '../1frf_api.dart';
import '../config/config.dart';
import '../utilities/colors.dart';

class Task {
  final String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});
}

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final List<Task> tasks = [];
  bool isLoading = true;
  bool noData = false; // Yeni eklendi - veri yoksa true olacak

  Future<void> fetchAgentTasks() async {
    try {
      int? agentId = await GetId.getAgentId();
      var headers = {
        'Content-Type': 'application/json',
        'X-API-Key': API_KEY,
        'Cookie':
        'session=eyJlbWFpbCI6ImJpbGFsZmF6aWxAMWZyZi5jb20iLCJsb2dnZWRpbiI6dHJ1ZX0.ZMs8sg.ys9BWRCxGXwT5XJpJj69zQlEfMg'
      };
      var request = http.Request(
          'GET', Uri.parse('$BASE_DOMAIN${API_ENDPOINT}get/profile/$agentId'));
      //request.body = json.encode({"loggedin": 'true', "agent_id": agentId});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        final jsonData = json.decode(responseBody);

        if (jsonData.containsKey('agent_data')) {
          final agentData = jsonData['agent_data'];

          if (agentData.containsKey('agent_tasks')) {
            final agentTasksData = agentData['agent_tasks'];

            if (agentTasksData is String) {
              final Map<String, dynamic> parsedAgentTasks =
              json.decode(agentTasksData);

              final tasks = <Task>[];

              parsedAgentTasks.forEach((key, value) {
                final taskData = value as Map<String, dynamic>;
                final task = Task(
                  title: taskData['agent_task'] as String,
                  isCompleted: taskData['isCompleted'] == 'True',
                );

                tasks.add(task);
              });

              setState(() {
                this.tasks.clear(); // Mevcut görevleri temizle
                this.tasks.addAll(tasks); // Yeni verileri ekle
                isLoading = false;
                noData = tasks.isEmpty; // Veri yoksa noData'ya true ata
              });
            }
          }
        }
      } else {
        MySnackBar(context, response.reasonPhrase.toString());
      }
    } catch (error) {
      MySnackBar(context, 'Hata: $error');
    }
  }

  Future<void> _refreshTasks() async {
    await fetchAgentTasks();
  }

  @override
  void initState() {
    fetchAgentTasks();
    super.initState();
  }

  void addTask(String title) {
    setState(() {
      tasks.add(Task(title: title));
    });
  }

  void removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshTasks,
        child: isLoading
            ? const Center(
          child: SpinKitFadingCircle(color: CustomColors.accentColor),
        )
            : noData
            ? Center(
          child: Text("You don't have any tasks"), // Veri yoksa bu mesajı göster
        )
            : ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Dismissible(
              key: Key(task.title),
              onDismissed: (direction) {
                removeTask(index);
              },
              background: Container(
                color: CustomColors.primaryColor,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20.0),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: ListTile(
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                trailing: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    setState(() {
                      task.isCompleted = value!;
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    String newTask = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a Task'),
          content: TextField(
            onChanged: (value) {
              newTask = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter task name',
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                if (newTask.isNotEmpty) {
                  addTask(newTask);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
