

import 'package:abaez/data/api_repository.dart';
import 'package:abaez/helpers/tasks_card_helper.dart';
import 'package:flutter/material.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/api/service/task_service.dart';
import 'package:abaez/data/task_repository.dart';
import 'package:abaez/domain/task.dart';


class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  TaskScreenState createState() => TaskScreenState();
}

class TaskScreenState extends State<TaskScreen> {
  late TaskService _taskService;
  late List<Task> _tasks;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _taskService = TaskService(TaskRepository(), ApiRepository());  // Inicializa el servicio
    _tasks = [];
    _loadTasks();

    // Configurar el listener para el scroll infinito
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !_isLoading) {
        _loadMoreTasks();
      }
    });
  }

  Future<void> _loadTasks() async {
  setState(() {
    _isLoading = true;
  });

  try {
    final initialTasks = await _taskService.getTasksWithSteps();
    final moreTasks = await _taskService.getMoreTaskWithSteps(5);

    if (mounted) { 
      setState(() {
        _tasks = [...initialTasks, ...moreTasks];
      });
    }
  } finally {
    if (mounted) { 
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  Future<void> _loadMoreTasks() async {
    if (_isLoading) return; 

    setState(() {
      _isLoading = true;
    });

    try {
      final newTasks = await _taskService.getMoreTaskWithSteps(_tasks.length);

      setState(() {
        _tasks.addAll(newTasks);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('${AppConstants.tituloAppbar} - Total: ${_tasks.length}'), //Modificacion 3.2
    ),
    body: Container(
    color: Colors.grey[200]!,
    child: _tasks.isEmpty
        ? const Center(child: Text(AppConstants.listaVacia))
        : ListView.builder(
            controller: _scrollController,
            itemCount: _tasks.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _tasks.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final task = _tasks[index];
              return Dismissible(
                key: Key(task.titulo),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {
                  setState(() {
                    _tasks.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text('${AppConstants.tareaEliminada} ${task.titulo}')),
                  );
                },
                child: TaskCardHelper.buildTaskCard(
                  context,
                  _tasks,
                  index,
                  onEdit: (context, index) => _showTaskOptionsModal(context, index),
                ),
              );
            },
          ),
  ),

    floatingActionButton: FloatingActionButton(
      onPressed: () => _showTaskModal(context),
      child: const Icon(Icons.add),
    ),
  );
}

void _showTaskModal(BuildContext context) {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController stepsController = TextEditingController();
  final TextEditingController dateController = TextEditingController(); // Controlador para la fecha
  DateTime? selectedDate;

  String selectedPriority = 'normal';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(AppConstants.agregarTarea),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: AppConstants.tituloTarea),
              ),
              DropdownButtonFormField<String>(
                value: selectedPriority,
                items: ['normal', 'urgente']
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedPriority = value;
                  }
                },
                decoration: const InputDecoration(labelText: 'Prioridad'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: AppConstants.descripcionTarea),
              ),
              TextFormField(
                controller: dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: AppConstants.fechaTarea,
                  hintText: 'Seleccionar fecha',
                ),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    selectedDate = pickedDate;
                    dateController.text =
                        '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';

                    // Llamar al servicio para obtener los pasos
                    if (titleController.text.isNotEmpty) {
                      try {
                        final int numeroDePasos = 2;
                        final pasos = _taskService.obtenerPasos(
                          titleController.text,
                          selectedDate!,
                          numeroDePasos,
                        );
                        stepsController.text = pasos.join('\n');
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error al obtener los pasos')),
                          );
                        }
                      }
                    }
                  }
                },
              ),
              TextField(
                controller: stepsController,
                decoration: const InputDecoration(
                  labelText: 'Pasos (separados por líneas)',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppConstants.cancelar),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && selectedDate != null) {
                setState(() {
                  _tasks.add(Task(
                    titulo: titleController.text,
                    tipo: selectedPriority,
                    descripcion: descriptionController.text,
                    fechaLimite: selectedDate!,
                    pasos: stepsController.text.split('\n'),
                  ));
                });
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AppConstants.camposVacios)),
                );
              }
            },
            child: const Text(AppConstants.guardar),
          ),
        ],
      );
    },
  );
}

void _showTaskOptionsModal(BuildContext context, int index) {
  final task = _tasks[index];
  final TextEditingController titleController = TextEditingController(text: task.titulo);
  final TextEditingController descriptionController = TextEditingController(text: task.descripcion);
  final TextEditingController stepsController = TextEditingController(
    text: task.pasos.join('\n'), 
  );

  final TextEditingController dateController = TextEditingController(
      text: '${task.fechaLimite.day.toString().padLeft(2, '0')}/${task.fechaLimite.month.toString().padLeft(2, '0')}/${task.fechaLimite.year}'
        
  );
  DateTime? selectedDate = task.fechaLimite;

  
  String selectedPriority = task.tipo.isNotEmpty ? task.tipo : 'normal';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(AppConstants.editarTarea),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: AppConstants.tituloTarea),
              ),
              DropdownButtonFormField<String>(
                value: selectedPriority,
                items: ['normal', 'urgente']
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedPriority = value;
                  }
                },
                decoration: const InputDecoration(labelText: 'Prioridad'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: AppConstants.descripcionTarea),
              ),
              TextFormField(
                controller: dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: AppConstants.fechaTarea,
                  hintText: 'Seleccionar fecha',
                ),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    selectedDate = pickedDate;
                    dateController.text =
                        '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';

                    final int numeroDePasos = 2;
                    final updatedSteps = _taskService.obtenerPasos(task.titulo, selectedDate!, numeroDePasos);
                    stepsController.text = updatedSteps.join('\n'); 
                  }
                },
              ),
              TextField(
                controller: stepsController,
                decoration: const InputDecoration(
                  labelText: 'Pasos (separados por líneas)',
                ),
                maxLines: 3, 
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppConstants.cancelar),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  selectedPriority.isNotEmpty &&
                  descriptionController.text.isNotEmpty &&
                  selectedDate != null) {
                setState(() {
                  _tasks[index] = Task(
                    titulo: titleController.text,
                    tipo: selectedPriority, // Guardar la prioridad seleccionada
                    descripcion: descriptionController.text,
                    fechaLimite: selectedDate!,
                    pasos: stepsController.text.split('\n'), 
                  );
                });
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AppConstants.camposVacios)),
                );
              }
            },
            child: const Text(AppConstants.guardar),
          ),
        ],
      );
    },
  );
}
  
}