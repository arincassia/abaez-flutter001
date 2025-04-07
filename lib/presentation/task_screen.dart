import 'package:flutter/material.dart';
import 'package:abaez/constans.dart';
import 'package:abaez/data/task_repository.dart';

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskRepository = TaskRepository();
    final tasks = taskRepository.getTasks();

    return Scaffold(
      appBar: AppBar(title: Text(AppConstants.TITLE_APPBAR)),
      body: tasks.isNotEmpty
          ? ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                );
              },
            )
          : Center(child: Text(AppConstants.EMPTY_LIST)),
    );
  }
}