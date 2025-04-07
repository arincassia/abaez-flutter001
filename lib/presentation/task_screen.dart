import 'package:flutter/material.dart';
import 'package:abaez/constans.dart';
import 'package:abaez/api/service/task_service.dart';
import 'package:abaez/data/task_repository.dart';
import 'package:abaez/domain/task.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late TaskService _taskService; // Declaración de _taskService
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    _taskService = TaskService(TaskRepository()); // Inicialización de _taskService
    _tasks = _taskService.getAllTasks();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppConstants.TITLE_APPBAR)),
      body: _tasks.isEmpty
          ? Center(child: Text(AppConstants.EMPTY_LIST))
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(
                    _tasks[index].type == 'urgente' ? Icons.warning : Icons.task,
                  ),
                  title: Text(_tasks[index].title),
                   onTap: () => _showTaskOptionsModal(context, index),
                  
                );
                
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskModal(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showTaskModal(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController typeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Tarea'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(labelText: 'Tipo (opcional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    _tasks.add(Task(
                      title: titleController.text,
                     type: typeController.text.isNotEmpty
    ? typeController.text
    : '',
                    ));
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor, completa el título')),
                  );
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _showTaskOptionsModal(BuildContext context, int index) {
    final task = _tasks[index];
    final TextEditingController titleController =
        TextEditingController(text: task.title);
    final TextEditingController typeController =
        TextEditingController(text: task.type);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Tarea'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(labelText: 'Tipo (opcional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tasks[index] = Task(
                    title: titleController.text,
                   type: typeController.text.isNotEmpty
    ? typeController.text
    : '',
                  );
                });
                Navigator.of(context).pop();
              },
              child: Text('Guardar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tasks.removeAt(index); // Elimina la tarea de la lista
                });
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}