import 'package:abaez/data/task_repository.dart';
import 'package:abaez/domain/task.dart';

class TaskService {
  final TaskRepository _repository;
  TaskService(this._repository);

  List<Task> getAllTasks() {
    return _repository.getTasks();
  }

  List<Task> getUrgentTasks() {
    return _repository.getTasks().where((task) => task.type == 'urgente').toList();
  }

  void addTask(Task task) {
    // Aquí podrías implementar lógica adicional antes de agregar una tarea,
    // como validaciones o transformaciones.
    // Por ahora, asumimos que el repositorio tiene un método para agregar tareas.
    // _repository.addTask(task); // Si implementas un método addTask en el repositorio.
  }
}