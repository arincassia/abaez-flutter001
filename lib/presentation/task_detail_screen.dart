
import 'package:flutter/material.dart';
import 'package:abaez/domain/task.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final int indice; 
 const TaskDetailScreen({Key? key, required this.task, required this.indice}) : super(key: key);

  String _formatearFecha(DateTime? fecha) {
    if (fecha == null) return "Sin fecha";
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        title: Text(task.titulo),
      ),
      body: Center(
        child: SizedBox(
          width: 280,
          child: Card(
             color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                     'https://picsum.photos/200/300?random=$indice',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.titulo,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (task.pasos.isNotEmpty)
                       Text("${task.pasos[0]}",style: TextStyle(fontWeight: FontWeight.w200)),
                      if (task.pasos.length > 1)
                        Text("${task.pasos[1]}"),
                      if (task.pasos.length > 2)
                        Text("${task.pasos[2]}",),
                      const SizedBox(height: 12),
                      Text(
                        'Fecha límite: ${_formatearFecha(task.fechaLimite)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}