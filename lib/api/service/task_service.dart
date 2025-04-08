import 'package:abaez/data/task_repository.dart';
import 'package:abaez/domain/task.dart';

class TaskService {
  final TaskRepository _repository;
  TaskService(this._repository);
  final List<Task> _tasks = [];

  Future<List<Task>> getAllTasks() async {
    await Future.delayed(Duration(seconds: 0));
    return _repository.getTasks();
  }

  List<Task> getUrgentTasks() {
    return _repository.getTasks().where((task) => task.tipo == 'urgente').toList();
  }

  Future<List<Task>> getMoreTasks(int offset) async {
    await Future.delayed(Duration(seconds: 2));
    return _repository.getMoreTasks(offset: offset, limit: 5);
  }

  bool updateTask(int index, {String? title, String? type, String? description, DateTime? date}) {
    if (index < 0 || index >= _tasks.length) return false;
    final task = _tasks[index];
    _tasks[index] = Task(
      titulo: title ?? task.titulo,
      tipo: type ?? task.tipo,
      descripcion: description ?? task.descripcion,
      fechaLimite: date ?? task.fechaLimite,
    );
    return true;
  }

  bool addTask(Task task) {
    _tasks.add(task);
    print("Task added: ${task.titulo}, type: ${task.tipo}, description: ${task.descripcion}, date: ${task.fechaLimite}");
    return true;
  }

  bool deleteTask(int index) {
    if (index < 0 || index >= _tasks.length) return false;
    _tasks.removeAt(index);
    return true;
  }

  void fetchMoreTasks() {
    _tasks.addAll(_repository.getMoreTasks());
  }

    List<String> obtenerPasos(String titulo) {
    // Simula una consulta a un asistente de IA para generar pasos según el título de la tarea.
    return [
      'Paso 1: Planificar $titulo',
      'Paso 2: Ejecutar $titulo',
      'Paso 3: Revisar $titulo',
    ];
  }

}