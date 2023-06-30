import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/taks.dart';
import '../providers/task_provider.dart';

class TaskDetailAndEditScreen extends StatefulWidget {
  static const String routeName = "/task-detail-screen";
  final Task taskDetail;
  const TaskDetailAndEditScreen({required this.taskDetail, super.key});

  @override
  State<TaskDetailAndEditScreen> createState() =>
      _TaskDetailAndEditScreenState();
}

class _TaskDetailAndEditScreenState extends State<TaskDetailAndEditScreen> {
  TextEditingController? _taskController;
  bool? isfavorite, iscomplete;

  @override
  void initState() {
    _taskController = TextEditingController(text: widget.taskDetail.task);
    isfavorite = widget.taskDetail.isfavorite;
    iscomplete = widget.taskDetail.iscomplete;
    super.initState();
  }

  @override
  void dispose() {
    _taskController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: false);
    Task selectedTask = taskProvider.getTaskById(widget.taskDetail.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            onPressed: () {
              taskProvider.updateTask(
                selectedTask.id,
                _taskController!.text.trim(),
                iscomplete as bool,
                isfavorite as bool,
              );
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: TextField(
          controller: _taskController,
          maxLines: 20,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            prefixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isfavorite = !(isfavorite as bool);
                  // selectedTask.togolFavoriteTask();
                });
              },
              icon: Icon(
                isfavorite == true ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
            ),
            label: const Text('Task'),
            suffixIcon: Checkbox(
              value: iscomplete,
              activeColor: Colors.green,
              checkColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  iscomplete = !(iscomplete as bool);
                  // selectedTask.togolCompleteTask();
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
