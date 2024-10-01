import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDetailScreen extends StatelessWidget {
  final dynamic task;

  TaskDetailScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task['title'] ?? 'Titulo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task['title'] ?? 'Titulo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(task['description'] ?? 'Descripción: Mi rutina '),
            SizedBox(height: 10),
            Text("Fecha: ${task['dateTime'] != null ? DateFormat('yyyy-MM-dd').format(DateTime.parse(task['dateTime'])) : '22/09/2024'}"),
            SizedBox(height: 10),
            Text("Categoría: ${task['category'] ?? '  : Fuerza  '}"),
            SizedBox(height: 10),
            Text("Archivos Adjuntos:"),
            for (var attachment in task['attachments'] ?? [])
              Text(attachment),
          ],
        ),
      ),
    );
  }
}
