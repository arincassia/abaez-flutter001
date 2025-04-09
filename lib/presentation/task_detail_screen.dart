import 'package:flutter/material.dart';
import 'package:abaez/domain/task.dart';
import 'package:abaez/helpers/tasks_card_helper.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final int indice;

  const TaskDetailScreen({Key? key, required this.task, required this.indice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(task.titulo),
      ),
    body: TaskCardHelper.construirTarjetaDeportiva(context, task, indice),
    );
  }
}