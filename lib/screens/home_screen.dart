import 'package:flutter/material.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';
import 'package:animations/animations.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  HomeScreen({required this.toggleTheme});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiService apiService = ApiService();
  late Future<List<dynamic>> tasks;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    tasks = apiService.fetchTasks();
  }

  void _addTask(dynamic task) {
    setState(() {
      tasks = apiService.fetchTasks();
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks.then((taskList) {
        taskList[index]['completed'] = !taskList[index]['completed'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tareas'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: tasks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay tareas disponibles'));
                } else {
                  List<dynamic> filteredTasks = snapshot.data!.where((task) {
                    return task['title'].toLowerCase().contains(searchQuery.toLowerCase());
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      var task = filteredTasks[index];
                      return OpenContainer(
                        closedBuilder: (context, action) => ListTile(
                          title: Text(
                            task['title'] ?? 'Sin título',
                            style: TextStyle(
                              decoration: task['completed'] ? TextDecoration.lineThrough : TextDecoration.none,
                            ),
                          ),
                          trailing: Checkbox(
                            value: task['completed'],
                            onChanged: (bool? value) {
                              _toggleTaskCompletion(index);
                            },
                          ),
                        ),
                        openBuilder: (context, action) => TaskDetailScreen(task: task),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
          if (newTask != null) {
            _addTask(newTask);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
