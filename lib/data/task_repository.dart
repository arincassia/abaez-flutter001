import 'package:abaez/domain/task.dart';
class TaskRepository {
  

  List<Task> getTasks() {
    return [
      Task(title: 'Tarea 1', type: 'urgente', description: 'Descripción de la tarea 1', date: DateTime.now()),
      Task(title: 'Tarea 2', type: 'normal', description: 'Descripción de la tarea 2', date: DateTime.now()),
      Task(title: 'Tarea 3', type: 'urgente', description: 'Descripción de la tarea 3', date: DateTime.now()),
      Task(title: 'Tarea 4', type: 'normal', description: 'Descripción de la tarea 4', date: DateTime.now()), 
      Task(title: 'Tarea 5', type: 'urgente', description: 'Descripción de la tarea 5', date: DateTime.now()),
    
    ];
  }

   List<Task> getMoreTasks({int offset = 0, int limit = 5}) {
  // Simula la obtención de más tareas
  return List.generate(limit, (index) {
    final taskNumber = offset + index + 1;
    return Task(
      title: 'Tarea $taskNumber',
      type: taskNumber % 2 == 0 ? 'normal' : 'urgente',
      description: 'Descripción de la tarea $taskNumber', 
      date: DateTime.now().add(Duration(days: taskNumber)), 
    );
  });
}

}

