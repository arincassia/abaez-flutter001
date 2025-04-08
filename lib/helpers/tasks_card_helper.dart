import 'package:flutter/material.dart';
import 'package:abaez/domain/task.dart';
import 'package:abaez/components/card.dart';

class TaskCardHelper {
  static Widget buildTaskCard(BuildContext context, Task task, int index, Function(BuildContext, int) onEdit) {
    return BaseCard(
      leading: Icon(
  task.tipo.toLowerCase() == 'urgente' ? Icons.warning : Icons.task, 
  color: task.tipo.toLowerCase() == 'urgente' ? Colors.red : Colors.blue, 
),
      title: task.titulo,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tipo: ${task.tipo}'),
          Text('Descripción: ${task.descripcion}'),
          Text(
            'Fecha: ${task.fechaLimite != "null" ? '${task.fechaLimite.day.toString().padLeft(2, '0')}/${task.fechaLimite.month.toString().padLeft(2, '0')}/${task.fechaLimite.year}' : 'Sin fecha'}',
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
