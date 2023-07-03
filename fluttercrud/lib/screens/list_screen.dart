import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';

import '../widgets/task_item.dart';

enum SelectedOptions { logout }

class ListScreen extends StatelessWidget {
  static const String routeName = '/list-screen';
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskProvider userTaskProvider = Provider.of<TaskProvider>(context);

    return RefreshIndicator(
      onRefresh: () {
        return userTaskProvider.fetchTask();
      },
      child: Visibility(
        replacement: const Center(
          child: Text(
            'No task added yet.',
            style: TextStyle(fontSize: 20),
          ),
        ),
        visible: userTaskProvider.tasks.isNotEmpty,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 5),
          itemCount: userTaskProvider.tasks.length,
          itemBuilder: (cntxt, index) {
            return ChangeNotifierProvider.value(
              value: userTaskProvider.tasks[index],
              child: const TaskItem(),
            );
          },
        ),
      ),
    );
  }
}
