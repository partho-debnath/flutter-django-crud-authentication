import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Response;

import './taks.dart';

class TaskProvider with ChangeNotifier {
  static const String domain =
      'https://filesharingbd.pythonanywhere.com/task-manager-api/';

  List<Task> _tasks = [];
  String? email;
  String? token;

  TaskProvider({
    required this.email,
    required this.token,
    required List<Task> tasks,
  }) : _tasks = tasks;

  factory TaskProvider.fromJson(List<dynamic> jsonTaskList) {
    final List<Task> taskList = [];
    for (Map<String, dynamic> jsonTask in jsonTaskList) {
      taskList.insert(0, Task.fromJson(jsonTask));
    }
    return TaskProvider(email: null, token: null, tasks: taskList);
  }

  List<Task> get tasks {
    return _tasks;
  }

  List<Task> get favoriteTask {
    return tasks.where((task) => task.isfavorite == true).toList();
  }

  List<Task> get completedTask {
    return tasks.where((task) => task.iscomplete == true).toList();
  }

  void clear() {
    _tasks.clear();
  }

  Future<List<Task>> fetchTask() async {
    try {
      final Uri url = Uri.parse('${domain}task-list/');
      final Response response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'TOKEN $token',
        },
      );

      final List<dynamic> jsonTasks = json.decode(response.body);
      final TaskProvider taskProvider = TaskProvider.fromJson(jsonTasks);
      _tasks = taskProvider.tasks;
      return taskProvider.tasks;
    } catch (error) {
      throw error.toString();
    }
  }

  Task getTaskById(int id) {
    return _tasks.firstWhere((element) => element.id == id);
  }

  Future<void> updateTaskCompleted(int id) async {
    Task existingTask = getTaskById(id);
    try {
      final Uri url = Uri.parse('${domain}task-list/$id/update-task/');
      Map<String, dynamic> task = {
        'iscomplete': existingTask.iscomplete,
      };

      await http.patch(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'TOKEN $token',
        },
        body: json.encode(task),
      );
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> updateTaskFavorites(int id) async {
    Task existingTask = getTaskById(id);
    try {
      final Uri url = Uri.parse('${domain}task-list/$id/update-task/');
      Map<String, dynamic> task = {
        'isfavorite': existingTask.isfavorite,
      };

      await http.patch(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'TOKEN $token',
        },
        body: json.encode(task),
      );
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> updateTaskText(int id) async {
    Task existingTask = getTaskById(id);
    try {
      final Uri url = Uri.parse('${domain}task-list/$id/update-task/');
      Map<String, dynamic> task = {
        'task': existingTask.task,
      };

      await http.patch(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'TOKEN $token',
        },
        body: json.encode(task),
      );
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> updateTask(
      int id, String text, bool iscomplete, bool isfavorite) async {
    Task existingTask = getTaskById(id);
    try {
      final Uri url = Uri.parse('${domain}task-list/$id/update-task/');

      existingTask.setTask(
        task: text,
        iscomplete: iscomplete,
        isfavorite: isfavorite,
      );

      await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'TOKEN $token',
        },
        body: json.encode(existingTask),
      );
    } catch (error) {
      throw error.toString();
    }

    notifyListeners();
  }

  Future<void> deleteTaskFromList(int id) async {
    try {
      await deleteTask(id);
      tasks.removeWhere((item) => item.id == id);
    } catch (error) {
      throw error.toString();
    }

    notifyListeners();
  }

  Future<void> deleteTask(int id) async {
    try {
      final Uri url = Uri.parse('${domain}task-list/$id/delete-task/');
      await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'TOKEN $token',
        },
      );
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> addNewTask(String task, bool complete, bool favorite) async {
    final Task tempTask = Task(
      id: 0,
      task: task,
      iscomplete: complete,
      isfavorite: favorite,
      created: "",
      updated: '',
    );

    try {
      final Uri url = Uri.parse('${domain}create-user-task/');
      final Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'TOKEN $token',
        },
        body: json.encode(tempTask),
      );
      Map<String, dynamic> jsonTask = json.decode(response.body);
      _tasks.insert(0, Task.fromJson(jsonTask));
      notifyListeners();
    } catch (error) {
      throw error.toString();
    }
  }
}
