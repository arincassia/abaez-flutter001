import 'package:abaez/domain/task.dart';
import 'package:abaez/data/api_repository.dart'; 

class TaskRepository {
  final ApiRepository apiRepository = ApiRepository(); 

  List<Task> getTasks() {
    return [
      Task(
        titulo: 'Tarea 1',
        tipo: 'urgente',
        descripcion: 'Descripción de la tarea 1',
        fechaLimite: DateTime.now().add(Duration(days: 3)),
        pasos: [],
      ),
      Task(
        titulo: 'Tarea 2',
        tipo: 'normal',
        descripcion: 'Descripción de la tarea 2',
        fechaLimite: DateTime.now().add(Duration(days: 5)),
        pasos: [],
      ),
      Task(
        titulo: 'Tarea 3',
        tipo: 'urgente',
        descripcion: 'Descripción de la tarea 3',
        fechaLimite: DateTime.now().add(Duration(days: 7)),
        pasos: [],
      ),
      Task(
        titulo: 'Tarea 4',
        tipo: 'normal',
        descripcion: 'Descripción de la tarea 4',
        fechaLimite: DateTime.now().add(Duration(days: 10)),
        pasos: [],
      ),
      Task(
        titulo: 'Tarea 5',
        tipo: 'urgente',
        descripcion: 'Descripción de la tarea 5',
        fechaLimite: DateTime.now().add(Duration(days: 12)),
        pasos: [],
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
        pasos: apiRepository.obtenerPasos('Tarea $taskNumber', fechaLimite), 
      );
    });
  }
}