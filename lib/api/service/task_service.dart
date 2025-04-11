import 'package:abaez/data/api_repository.dart';
import 'package:abaez/data/task_repository.dart';
import 'package:abaez/domain/task.dart';


class TaskService {
  final TaskRepository _repository;
  final ApiRepository _apiRepository;
  

  TaskService(this._repository, this._apiRepository);

  final List<Task> _tasks = [];

  Future<List<Task>> getTasksWithSteps() async {
    final tasks = await _repository.getTasks();

    final updatedTasks = await Future.wait(tasks.map((task) async {
      try {
        // Elimina el 'await' si obtenerPasos no es asíncrono
        var pasos = _apiRepository.obtenerPasos(task.titulo, task.fechaLimite, 2);
        pasos = pasos.take(2).toList();
        return Task(
          titulo: task.titulo,
          tipo: task.tipo,
          descripcion: task.descripcion,
          fechaLimite: task.fechaLimite,
          pasos: pasos,
        );
      } catch (e) {
        //print("Error al obtener pasos para la tarea '${task.titulo}': $e");
        return task;
      }
    }).toList());

    return updatedTasks;
  }

  Future<List<Task>> getMoreTaskWithSteps(int offset) async {
    final tasks = await _repository.getMoreTasks(offset: offset, limit: 5);

    final updatedTasks = await Future.wait(tasks.map((task) async {
      try {
        // Elimina el 'await' si obtenerPasos no es asíncrono
        var pasos = _apiRepository.obtenerPasos(task.titulo, task.fechaLimite, 2);
        pasos = pasos.take(2).toList();
        return Task(
          titulo: task.titulo,
          tipo: task.tipo,
          descripcion: task.descripcion,
          fechaLimite: DateTime.now().add(const Duration(days: 1)),
          pasos: pasos,
        );
      } catch (e) {
        //print("Error al obtener pasos para la tarea '${task.titulo}': $e");
        return task;
      }
    }).toList());

    return updatedTasks;
  }


  List<String> obtenerPasos(String titulo, DateTime fecha, int numeroDePasos) {
    return _apiRepository.obtenerPasos(titulo, fecha, numeroDePasos);
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
    //print("Task added: ${task.titulo}, type: ${task.tipo}, description: ${task.descripcion}, date: ${task.fechaLimite}"); // Replace print
    return true;
  }

  bool deleteTask(int index) {
    if (index < 0 || index >= _tasks.length) return false;
    _tasks.removeAt(index);
    return true;
  }

  Future<void> fetchMoreTasks() async {
    final moreTasks = await _repository.getMoreTasks(offset: _tasks.length, limit: 5);
    _tasks.addAll(moreTasks);
  }
}