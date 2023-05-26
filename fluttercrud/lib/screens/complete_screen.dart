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
    final List<Task> favoriteTask = taskProvider.completedTask;
    return ListView.builder(
      itemCount: favoriteTask.length,
      itemBuilder: (cntxt, index) {
        return Column(
          children: [
            ListTile(
              leading: const Icon(
                Icons.done,
                color: Colors.green,
              ),
              title: Text(favoriteTask[index].task),
              subtitle: Text(DateFormat.yMMMMEEEEd()
                  .format(DateTime.parse(favoriteTask[index].updated))),
              trailing: const Icon(
                Icons.favorite,
                color: Colors.red,
              ),
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
