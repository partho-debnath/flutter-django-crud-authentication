import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/task_provider.dart';
import '../providers/taks.dart';

class ListScreen extends StatelessWidget {
  static const String routeName = '/list-screen';
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskProvider userTaskProvider =
        Provider.of<TaskProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Tasks'),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return userTaskProvider.fetchTask();
        },
        child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            itemCount: userTaskProvider.tasks.length,
            itemBuilder: (cntxt, index) {
              return ChangeNotifierProvider.value(
                value: userTaskProvider.tasks[index],
                child: const TaskItem(),
              );
            }),
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  const TaskItem({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskProvider userTaskProvider =
        Provider.of<TaskProvider>(context, listen: true);
    final Task task = Provider.of<Task>(context, listen: false);
    return Card(
      elevation: 5,
      child: ListTile(
        title: Text(task.task),
        subtitle:
            Text(DateFormat.yMMMMEEEEd().format(DateTime.parse(task.created))),
        leading: Consumer<Task>(
          builder: (cntxt, myTask, child) {
            return IconButton(
              onPressed: () {
                myTask.togolFavoriteTask();
                userTaskProvider.updateTaskFavorites(myTask.id);
              },
              icon: Icon(
                myTask.isfavorite == true
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              ),
            );
          },
        ),
        trailing: Consumer<Task>(
          builder: (context, _task, child) {
            return Checkbox(
              value: _task.iscomplete,
              activeColor: Colors.green,
              checkColor: Colors.white,
              onChanged: (value) {
                _task.togolCompleteTask();
                userTaskProvider.updateTaskCompleted(_task.id);
              },
            );
          },
        ),
        onTap: () {
          debugPrint(task.id.toString());
        },
      ),
    );
  }
}
