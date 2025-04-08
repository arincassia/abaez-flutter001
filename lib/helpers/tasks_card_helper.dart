//task_card_helper

import 'package:flutter/material.dart';
import 'package:abaez/domain/task.dart';
import 'package:abaez/components/card.dart';
import "package:abaez/constans.dart";
import 'package:abaez/presentation/task_detail_screen.dart';

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

  static Widget construirTarjetaDeportiva(
    BuildContext context,
    Task task,
    int indice, {
    Function(BuildContext, int)? onEdit,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailScreen(task: task, indice: indice),
          ),
        );
      },
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 8),
            Image.network(
              'https://picsum.photos/200/300?random=$indice',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
            ),
             Row(
              children: [
                Icon(
                  task.tipo.toLowerCase() == 'urgente'
                      ? Icons.warning
                      : Icons.task,
                  color: task.tipo.toLowerCase() == 'urgente'
                      ? Colors.red
                      : Colors.blue,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    task.titulo,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (task.pasos.isNotEmpty)
                    Text('${task.pasos[0]}'),
                  const SizedBox(height: 8),
                  Text(
                    task.fechaLimite != "null"
                        ? '${AppConstants.FECHA_LIMITE} ${task.fechaLimite.day.toString().padLeft(2, '0')}/${task.fechaLimite.month.toString().padLeft(2, '0')}/${task.fechaLimite.year}'
                        : '${AppConstants.FECHA_LIMITE} Sin fecha',
                  ),
                ],
              ),
            ),
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => onEdit(context, indice),
              ),
          ],
        ),
      ),
    );
  }
}


  