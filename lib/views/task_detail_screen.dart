import 'package:flutter/material.dart';
import 'package:abaez/domain/tarea.dart';
import 'package:abaez/helpers/tasks_card_helper.dart';

class TaskDetailScreen extends StatelessWidget {
  final List<Tarea> tasks;
  final int initialIndex;

  const TaskDetailScreen({
    super.key, required this.tasks, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Detalles de la Tarea'),
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