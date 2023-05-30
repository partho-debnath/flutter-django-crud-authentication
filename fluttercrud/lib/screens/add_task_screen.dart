import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  static const String routeName = 'add-new-task-screen/';
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController? _taskController;
  bool isFavorite = false;
  bool isComplete = false;
  String? errorMessage = null;

  @override
  void initState() {
    _taskController = TextEditingController();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Your Task'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _taskController,
                maxLines: 15,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  labelText: 'Task',
                  prefixIcon: buildFavoriteButton(),
                  suffixIcon: buildCompleteButton(),
                  errorText: errorMessage,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  OutlinedButton.icon(
                    onPressed: () {
                      if (_taskController!.text.trim().isNotEmpty) {
                        showDialogButton(context).then((bool? value) {
                          if (value == true) {
                            Navigator.of(context).pop();
                          }
                        });
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                    label: const Text('Cancel'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      if (_taskController!.text.isNotEmpty == true) {
                        taskProvider.addNewTask(
                          _taskController!.text.trim(),
                          isComplete,
                          isFavorite,
                        );
                        errorMessage = null;
                        _taskController!.text = '';
                        isComplete = false;
                        isFavorite = false;
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Task added successfully.'),
                        ));
                      } else {
                        errorMessage =
                            'Your task is empty. Please write a task First.';
                      }
                      setState(() {});
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Checkbox buildCompleteButton() {
    return Checkbox(
      value: isComplete,
      onChanged: (value) {
        setState(() {
          isComplete = !isComplete;
        });
      },
      activeColor: Colors.green,
    );
  }

  IconButton buildFavoriteButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          isFavorite = !isFavorite;
        });
      },
      icon: Icon(
        isFavorite == false ? Icons.favorite_border : Icons.favorite,
        color: Colors.red,
      ),
    );
  }

  Future<bool?> showDialogButton(BuildContext context) {
    return showDialog<bool?>(
      context: context,
      builder: (cntxt) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to close this without saving?'),
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
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
