//task_screen
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
    _taskService = TaskService(TaskRepository()); // Inicializa el servicio
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
      
      final initialTasks = await _taskService.getAllTasks();
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
    appBar: AppBar(title: Text(AppConstants.TITLE_APPBAR)),
    body: Container(
      color: Colors.grey[200],
      child: _tasks.isEmpty
          ? Center(child: Text(AppConstants.EMPTY_LIST))
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
        SnackBar(content: Text('${task.titulo} eliminada')),
      );
    },
    child: TaskCardHelper.construirTarjetaDeportiva(
  context,
  task,
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
  DateTime? selectedDate;
   final TextEditingController stepsController = TextEditingController(); 

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppConstants.ADD_TASK_TITLE),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: AppConstants.TITLE_LABEL),
              ),
              TextField(
                controller: typeController,
                decoration: InputDecoration(labelText: AppConstants.TYPE_LABEL),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: AppConstants.DESCRIPTION_LABEL),
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
                  }
                },
                child: Text(AppConstants.SELECT_DATE_BUTTON),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppConstants.CANCEL_BUTTON),
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
                    pasos: stepsController.text.split('\n'),
                  ));
                });
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppConstants.EMPTY_FIELDS_ERROR)),
                );
              }
            },
            child: Text(AppConstants.SAVE_BUTTON),
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
        title: Text(AppConstants.EDIT_TASK_TITLE),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: AppConstants.TITLE_LABEL),
              ),
              TextField(
                controller: typeController,
                decoration: InputDecoration(labelText: AppConstants.TYPE_LABEL),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: AppConstants.DESCRIPTION_LABEL),
              ),
              TextFormField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: AppConstants.DATE_LABEL,
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

                   
                    final updatedSteps = TaskRepository().obtenerPasos(task.titulo, selectedDate!);
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
            child: Text(AppConstants.CANCEL_BUTTON),
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
                  SnackBar(content: Text(AppConstants.EMPTY_FIELDS_ERROR)),
                );
              }
            },
            child: Text(AppConstants.SAVE_BUTTON),
          ),
          
        ],
      );
    },
  );
}
  
}