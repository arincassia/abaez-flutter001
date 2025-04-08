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
    return _repository.getTasks().where((task) => task.type == 'urgente').toList();
  }

  Future<List<Task>> getMoreTasks(int offset) async {
    await Future.delayed(Duration(seconds: 2));
    return _repository.getMoreTasks(offset: offset, limit: 5);
  }

  bool updateTask(int index, {String? title, String? type, String? description, DateTime? date}) {
    if (index < 0 || index >= _tasks.length) return false;
    final task = _tasks[index];
    _tasks[index] = Task(
      title: title ?? task.title,
      type: type ?? task.type,
      description: description ?? task.description,
      date: date ?? task.date,
    );
    return true;
  }

  bool addTask(Task task) {
    _tasks.add(task);
    print("Task added: ${task.title}, type: ${task.type}, description: ${task.description}, date: ${task.date}");
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