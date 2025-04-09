

import 'package:abaez/data/api_repository.dart';
import 'package:abaez/data/task_repository.dart';

import 'package:abaez/domain/task.dart';

class TaskService {
  final TaskRepository _repository;
  final ApiRepository _apiRepository;
  
  TaskService(this._repository, this._apiRepository);


 
  final List<Task> _tasks = [];

  Future<List<Task>> getAllTasks() async {
  await Future.delayed(Duration(seconds: 0));
  final tasks = await _repository.getTasks();

  // Crear una nueva lista de tareas con los pasos actualizados
  final updatedTasks = await Future.wait(tasks.map((task) async {
    try {
      final pasos = await obtenerPasos(task.titulo, task.fechaLimite);
      return Task(
        titulo: task.titulo,
        tipo: task.tipo,
        descripcion: task.descripcion,
        fechaLimite: task.fechaLimite,
        pasos: pasos, // Asignar los pasos obtenidos
      );
    } catch (e) {
      print("Error al obtener pasos para la tarea '${task.titulo}': $e");
      return task; // Retornar la tarea original si hay un error
    }
  }));

  return updatedTasks;
}

  List<Task> getUrgentTasks() {
    return _repository.getTasks().where((task) => task.tipo == 'urgente').toList();
  }

  Future<List<Task>> getMoreTasks(int offset) async {
    await Future.delayed(Duration(seconds: 2));
    return _repository.getMoreTasks(offset: offset, limit: 5);
  }

   Future<List<String>> obtenerPasos(String titulo, DateTime fecha) async {
    return _apiRepository.obtenerPasos(titulo, fecha);
  }


  bool updateTask(int index, {String? title, String? type, String? description, DateTime? date}) {
    if (index < 0 || index >= _tasks.length) return false;
    final task = _tasks[index];
    _tasks[index] = Task(
      titulo: title ?? task.titulo,
      tipo: type ?? task.tipo,
      descripcion: description ?? task.descripcion,
      fechaLimite: date ?? task.fechaLimite,
      pasos: task.pasos,
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

   

}