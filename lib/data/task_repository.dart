import 'package:abaez/domain/task.dart';

class TaskRepository {
  List<Task> getTasks() {
    return [
      Task(title: 'Tarea 1', type:'urgente'),
      Task(title: 'Tarea 2'),
      Task(title: 'Tarea 3', type:'normal'),
      Task(title: 'Tarea 4'),
      Task(title: 'Tarea 5'),
    ];
  }
}

