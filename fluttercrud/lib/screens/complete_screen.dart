import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/task_provider.dart';
import '../providers/taks.dart';

class CompleteScreen extends StatelessWidget {
  const CompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: false);
    final List<Task> completedTask = taskProvider.completedTask;

    if (completedTask.isEmpty == true) {
      return const Center(
        child: Text(
          'No completed tasks.',
          style: TextStyle(
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return ListView.builder(
        itemCount: completedTask.length,
        itemBuilder: (cntxt, index) {
          return Column(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.done,
                  color: Colors.green,
                ),
                title: Text(completedTask[index].getTaskAsTitle),
                subtitle: Text(DateFormat.yMMMMEEEEd()
                    .format(DateTime.parse(completedTask[index].updated))),
              ),
              const Divider(
                color: Colors.grey,
              )
            ],
          );
        },
      );
    }
  }
}
