import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

import '../providers/task_provider.dart';
import '../providers/taks.dart';
import '../screens/details_and_edit_screen.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskProvider userTaskProvider = Provider.of<TaskProvider>(context);
    final Task task = Provider.of<Task>(context, listen: false);

    return Dismissible(
      key: ValueKey(task.id),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Delete'),
            SizedBox(width: 20),
            Icon(Icons.delete),
          ],
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          await userTaskProvider.deleteTaskFromList(task.id);
        }
      },
      confirmDismiss: (direction) {
        return showDialog<bool>(
            context: context,
            builder: (cntxt) {
              return AlertDialog(
                icon: const Icon(Icons.delete_forever),
                iconColor: Colors.red,
                title: const Text('Are you sure?'),
                content: const Text(
                  'Do you want to delete this task?',
                ),
                alignment: Alignment.center,
                actionsAlignment: MainAxisAlignment.spaceAround,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(cntxt).pop(false);
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(cntxt).pop(true);
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              );
            });
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        elevation: 5,
        child: ListTile(
          title: Text(task.getTaskAsTitle),
          subtitle: Text(
              DateFormat.yMMMMEEEEd().format(DateTime.parse(task.created))),
          leading: Consumer<Task>(
            builder: (cntxt, myTask, child) {
              return IconButton(
                onPressed: () async {
                  myTask.togolFavoriteTask();
                  await userTaskProvider.updateTaskFavorites(myTask.id);
                },
                icon: Visibility(
                  replacement: const Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                  ),
                  visible: myTask.isfavorite,
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
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
                onChanged: (value) async {
                  _task.togolCompleteTask();
                  await userTaskProvider.updateTaskCompleted(_task.id);
                },
              );
            },
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TaskDetailAndEditScreen(
                  taskDetail: task,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
