import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/task_provider.dart';
import '../providers/taks.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: false);
    final List<Task> favoriteTask = taskProvider.favoriteTask;
    if (favoriteTask.isEmpty == true) {
      return const Center(
        child: Text(
          'No favorite task added yet.',
          style: TextStyle(
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return ListView.separated(
        itemCount: favoriteTask.length,
        separatorBuilder: (cntxt, index) => const Divider(
          color: Colors.grey,
          indent: 5,
          endIndent: 5,
        ),
        itemBuilder: (cntxt, index) {
          return ListTile(
            title: Text(favoriteTask[index].getTaskAsTitle),
            subtitle: Text(DateFormat.yMMMMEEEEd()
                .format(DateTime.parse(favoriteTask[index].created))),
            trailing: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          );
        },
      );
    }
  }
}
