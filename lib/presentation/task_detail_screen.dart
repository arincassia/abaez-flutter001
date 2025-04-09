import 'package:flutter/material.dart';
import 'package:abaez/domain/task.dart';
import 'package:abaez/helpers/tasks_card_helper.dart';

class TaskDetailScreen extends StatelessWidget {
  final List<Task> tasks;
  final int initialIndex;

  const TaskDetailScreen({Key? key, required this.tasks, required this.initialIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Detalles de la Tarea'),
      ),
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskCardHelper.construirTarjetaDeportiva(context, tasks[index], index);
        },
      ),
    );
  }
}