import 'package:abaez/domain/task.dart';
import 'package:abaez/data/api_repository.dart'; // Importa el archivo donde está obtenerPasos

class TaskRepository {
  final ApiRepository apiRepository = ApiRepository(); // Crea una instancia de ApiRepository

  List<Task> getTasks() {
    return [
      Task(
        titulo: 'Tarea 1',
        tipo: 'urgente',
        descripcion: 'Descripción de la tarea 1',
        fechaLimite: DateTime.now().add(Duration(days: 3)),
        pasos: obtenerPasos('Tarea 1', DateTime.now().add(Duration(days: 3))), // Llama a obtenerPasos
      ),
      Task(
        titulo: 'Tarea 2',
        tipo: 'normal',
        descripcion: 'Descripción de la tarea 2',
        fechaLimite: DateTime.now().add(Duration(days: 5)),
        pasos: obtenerPasos('Tarea 2', DateTime.now().add(Duration(days: 5))), // Llama a obtenerPasos
      ),
      Task(
        titulo: 'Tarea 3',
        tipo: 'urgente',
        descripcion: 'Descripción de la tarea 3',
        fechaLimite: DateTime.now().add(Duration(days: 7)),
        pasos: obtenerPasos('Tarea 3', DateTime.now().add(Duration(days: 7))), // Llama a obtenerPasos
      ),
      Task(
        titulo: 'Tarea 4',
        tipo: 'normal',
        descripcion: 'Descripción de la tarea 4',
        fechaLimite: DateTime.now().add(Duration(days: 10)),
        pasos: obtenerPasos('Tarea 4', DateTime.now().add(Duration(days: 10))), // Llama a obtenerPasos
      ),
      Task(
        titulo: 'Tarea 5',
        tipo: 'urgente',
        descripcion: 'Descripción de la tarea 5',
        fechaLimite: DateTime.now().add(Duration(days: 12)),
        pasos: obtenerPasos('Tarea 5', DateTime.now().add(Duration(days: 12))), // Llama a obtenerPasos
      ),
    ];
  }

  List<Task> getMoreTasks({int offset = 0, int limit = 5}) {
    // Simula la obtención de más tareas
    return List.generate(limit, (index) {
      final taskNumber = offset + index + 1;
      final fechaLimite = DateTime.now().add(Duration(days: taskNumber));
      return Task(
        titulo: 'Tarea $taskNumber',
        tipo: taskNumber % 2 == 0 ? 'normal' : 'urgente',
        descripcion: 'Descripción de la tarea $taskNumber',
        fechaLimite: fechaLimite,
        pasos: obtenerPasos('Tarea $taskNumber', fechaLimite), // Llama a obtenerPasos
      );
    });
  }

   List<String> obtenerPasos(String titulo, DateTime fechaLimite) {
    // Formatear la fecha manualmente
    final String fechaFormateada =
        '${fechaLimite.day.toString().padLeft(2, '0')}/${fechaLimite.month.toString().padLeft(2, '0')}/${fechaLimite.year}';
  // Generar pasos personalizados con la fecha límite
    return [
      'Paso 1: Planificar antes del $fechaFormateada',
      'Paso 2: Ejecutar antes del $fechaFormateada',
      'Paso 3: Revisar antes del $fechaFormateada',
    ];
  }
}