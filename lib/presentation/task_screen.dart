

import 'package:abaez/data/api_repository.dart';
import 'package:abaez/helpers/tasks_card_helper.dart';
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
      final moreTasks = await _taskService.getMoreTasks(5);
      setState(() {
        _tasks = [...initialTasks, ...moreTasks];

      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreTasks() async {
    if (_isLoading) return; 

    setState(() {
      _isLoading = true;
    });

    try {
      final newTasks = await _taskService.getMoreTasks(_tasks.length);

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
    appBar: AppBar(title: Text(AppConstants.TITULO_APPBAR)),
    body: Container(
    color: Colors.grey[200]!,
    child: _tasks.isEmpty
        ? Center(child: Text(AppConstants.LISTA_VACIA))
        : ListView.builder(
            controller: _scrollController,
            itemCount: _tasks.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _tasks.length) {
                return Center(child: CircularProgressIndicator());
              }
              final task = _tasks[index];
              return Dismissible(
                key: Key(task.titulo),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {
                  setState(() {
                    _tasks.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text('${AppConstants.TAREA_ELIMINADA} ${task.titulo}')),
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
      child: Icon(Icons.add),
    ),
  );
}
void _showTaskModal(BuildContext context) {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController stepsController = TextEditingController(); // Controlador para los pasos
  DateTime? selectedDate;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppConstants.AGREGAR_TAREA),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: AppConstants.TITULO_TAREA),
              ),
              TextField(
                controller: typeController,
                decoration: InputDecoration(labelText: AppConstants.TIPO_TAREA),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: AppConstants.DESCRIPCION_TAREA),
              ),
              TextField(
                controller: stepsController,
                decoration: InputDecoration(
                  labelText: 'Pasos (separados por líneas)', // Etiqueta para los pasos
                ),
                maxLines: 3, // Permitir múltiples líneas
              ),
              TextButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    selectedDate = pickedDate;

                    // Llamar al servicio para obtener los pasos
                    if (titleController.text.isNotEmpty) {
                      try {
                        final int numeroDePasos = 3;
                        final pasos = await _taskService.obtenerPasos(
                          titleController.text,
                          selectedDate!,
                          numeroDePasos
                        );
                        stepsController.text = pasos.join('\n'); // Actualizar el controlador
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al obtener los pasos')),
                        );
                      }
                    }
                  }
                },
                child: Text(AppConstants.SELECCIONAR_FECHA),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppConstants.CANCELAR),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && selectedDate != null) {
                setState(() {
                  _tasks.add(Task(
                    titulo: titleController.text,
                    tipo: typeController.text.isNotEmpty ? typeController.text : '',
                    descripcion: descriptionController.text,
                    fechaLimite: selectedDate!,
                    pasos: stepsController.text.split('\n'), // Procesar los pasos
                  ));
                });
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppConstants.CAMPOS_VACIOS)),
                );
              }
            },
            child: Text(AppConstants.GUARDAR),
          ),
        ],
      );
    },
  );
}
void _showTaskOptionsModal(BuildContext context, int index) {
  final task = _tasks[index];
  final TextEditingController titleController = TextEditingController(text: task.titulo);
  final TextEditingController typeController = TextEditingController(text: task.tipo);
  final TextEditingController descriptionController = TextEditingController(text: task.descripcion);
  final TextEditingController stepsController = TextEditingController(
    text: task.pasos.join('\n'), 
  );

  final TextEditingController dateController = TextEditingController(
    text: task.fechaLimite != "null"
        ? '${task.fechaLimite.day.toString().padLeft(2, '0')}/${task.fechaLimite.month.toString().padLeft(2, '0')}/${task.fechaLimite.year}'
        : '',
  );
  DateTime? selectedDate = task.fechaLimite;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppConstants.EDITAR_TAREA),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: AppConstants.TITULO_TAREA),
              ),
              TextField(
                controller: typeController,
                decoration: InputDecoration(labelText: AppConstants.TIPO_TAREA),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: AppConstants.DESCRIPCION_TAREA),
              ),
              TextFormField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: AppConstants.FECHA_TAREA,
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

                    final int numeroDePasos = 3;
                    final updatedSteps = await _taskService.obtenerPasos(task.titulo, selectedDate!, numeroDePasos);
                    stepsController.text = updatedSteps.join('\n'); 
                  }
                },
              ),
              TextField(
                controller: stepsController,
                decoration: InputDecoration(
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
            child: Text(AppConstants.CANCELAR),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  typeController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty &&
                  selectedDate != null) {
                setState(() {
                  _tasks[index] = Task(
                    titulo: titleController.text,
                    tipo: typeController.text,
                    descripcion: descriptionController.text,
                    fechaLimite: selectedDate!,
                    pasos: stepsController.text.split('\n'), 
                  );
                });
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppConstants.CAMPOS_VACIOS)),
                );
              }
            },
            child: Text(AppConstants.GUARDAR),
          ),
          
        ],
      );
    },
  );
}
  
}