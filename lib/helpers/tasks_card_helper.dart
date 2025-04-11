
import 'package:abaez/helpers/common_widgets_helper.dart';
import 'package:flutter/material.dart';
import 'package:abaez/domain/task.dart';
import "package:abaez/constans.dart";
import 'package:abaez/presentation/task_detail_screen.dart';

class TaskCardHelper {
static Widget buildTaskCard(
  BuildContext context,
  List<Task> tasks,
  int indice, {
  Function(BuildContext, int)? onEdit,
}) {
  final task = tasks[indice];

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaskDetailScreen(tasks: tasks, initialIndex: indice),
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              'https://picsum.photos/200/300?random=$indice',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
            ),
          ),

          // Título y tipo
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    task.titulo,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${AppConstants.tipoTarea}: ${task.tipo}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      task.tipo.toLowerCase() == 'urgente' ? Icons.warning : Icons.task,
                      color: task.tipo.toLowerCase() == 'urgente' ? Colors.red : Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Descripción
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Descripción: ${task.descripcion}',
              style: const TextStyle(fontSize: 16),
            ),
          ),

          // Pasos
          if (task.pasos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppConstants.pasosTitulo,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.pasos[0],
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),

          // Fecha límite
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
           child: Text(
             '${AppConstants.fechaLimite} ${task.fechaLimite.day.toString().padLeft(2, '0')}/${task.fechaLimite.month.toString().padLeft(2, '0')}/${task.fechaLimite.year}',
              style: const TextStyle(fontSize: 16),
            ),
           ),

          // Botón de edición
          if (onEdit != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => onEdit(context, indice),
                  ),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}


  static Widget construirTarjetaDeportiva(BuildContext context, Task task, int indice) {
  final helper = CommonWidgetsHelper();

  return Center( // Modificación 3.1
      child: Card(
        margin: const EdgeInsets.all(50), // Margen externo
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8, // Sombra del Card
        child: Container(
          padding: const EdgeInsets.all(16), // Padding interno
          decoration: helper.buildRoundedBorder(), // Borde redondeado
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://picsum.photos/200/300?random=$indice',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              helper.buildSpacing(), // Espaciado

              // Título
              helper.buildBoldTitle(task.titulo),
              helper.buildSpacing(), // Espaciado

              // Pasos
              helper.buildInfoLines(
                task.pasos.isNotEmpty ? task.pasos[0] : "Sin pasos",
                line2: task.pasos.length > 1 ? task.pasos[1] : null,
                line3: task.pasos.length > 2 ? task.pasos[2] : null,
              ),
              helper.buildSpacing(), // Espaciado

              // Fecha límite
              helper.buildBoldFooter(
                'Fecha límite: ${_formatearFecha(task.fechaLimite)}',
              ),
            ],
          ),
        ),
      ),
    );
}

}

String _formatearFecha(DateTime? fecha) {
    if (fecha == null) return "Sin fecha";
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }

  