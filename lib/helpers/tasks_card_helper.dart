import 'package:flutter/material.dart';
import 'package:abaez/domain/task.dart';
import 'package:abaez/components/card.dart';

class TaskCardHelper {
  static Widget buildTaskCard(BuildContext context, Task task, int index, Function(BuildContext, int) onEdit) {
    return BaseCard(
      leading: Icon(
  task.type.toLowerCase() == 'urgente' ? Icons.warning : Icons.task, 
  color: task.type.toLowerCase() == 'urgente' ? Colors.red : Colors.blue, 
),
      title: task.title,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tipo: ${task.type}'),
          Text('Descripción: ${task.description}'),
          Text(
            'Fecha: ${task.date != "null" ? '${task.date.day.toString().padLeft(2, '0')}/${task.date.month.toString().padLeft(2, '0')}/${task.date.year}' : 'Sin fecha'}',
          ), 
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () => onEdit(context, index),
      ),
    );
  }
}
