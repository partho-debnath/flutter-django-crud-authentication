import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  }) {
    _tasks = tasks;
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
    List<Task> tasks = [];
    try {
      var url = Uri.parse('${domain}task-list/');
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'TOKEN $token',
        },
      );

      List<dynamic> listOfTask = json.decode(response.body);
      for (Map<String, dynamic> item in listOfTask) {
        tasks.add(Task(
          id: item['id'],
          task: item['task'],
          isfavorite: item['isfavorite'],
          iscomplete: item['iscomplete'],
          created: item['created'],
          updated: item['updated'],
        ));
      }
    } catch (error) {
      throw error.toString();
    }
    _tasks = tasks;
    return _tasks;
  }

  Task getTaskById(int id) {
    return _tasks.firstWhere((element) => element.id == id);
  }

  Future<void> updateTaskCompleted(int id) async {
    Task existingTask = getTaskById(id);
    try {
      var url = Uri.parse('${domain}task-list/$id/update-task/');
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
      var url = Uri.parse('${domain}task-list/$id/update-task/');
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
      var url = Uri.parse('${domain}task-list/$id/update-task/');
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
      var url = Uri.parse('${domain}task-list/$id/update-task/');
      Map<String, dynamic> task = {
        'id': existingTask.id,
        'task': text,
        'iscomplete': iscomplete,
        'isfavorite': isfavorite,
      };

      await http.put(
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
      var url = Uri.parse('${domain}task-list/$id/delete-task/');
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
    Map<String, dynamic> userTask = {
      'task': task,
      'iscomplete': complete,
      'isfavorite': favorite,
    };

    try {
      var url = Uri.parse('${domain}create-user-task/');
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'TOKEN $token',
        },
        body: json.encode(userTask),
      );
      Map<String, dynamic> userNewTask = json.decode(response.body);
      Task newTask = Task(
        id: userNewTask['id'],
        task: userNewTask['task'],
        iscomplete: userNewTask['iscomplete'],
        isfavorite: userNewTask['isfavorite'],
        created: userNewTask['created'],
        updated: userNewTask['updated'],
      );
      _tasks.insert(0, newTask);
      notifyListeners();
    } catch (error) {
      throw error.toString();
    }
  }
}
