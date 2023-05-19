import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './taks.dart';
import './user.dart';

class TaskProvider with ChangeNotifier {
  static const String domain = 'http://10.0.2.2:8000/';

  List<Task> _tasks = [];
  User? _user;

  List<Task> get tasks {
    return _tasks;
  }

  Future<String?> loginUser(String email, String password) async {
    Map<String, String> user = {'username': email, 'password': password};

    try {
      var url = Uri.parse('${domain}api-token-auth/');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(user),
      );

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody.containsKey('token') == true) {
        /// Create the user 'emain & token ID', when the user login successfully
        _user = User(email: email, token: responseBody['token']);
      } else {
        ///  Return error, when the user provide wrong email and password
        return 'Email or password is incorrect.';
      }
    } catch (error) {
      /// throw ERROR, when any errors occurs.
      throw error.toString();
    }

    ///  Return null, when the user login successfully
    return null;
  }

  Future<void> fetchTask() async {
    List<Task> tasks = [];
    try {
      var url = Uri.parse('${domain}task-list/');
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'TOKEN ${_user!.getToken()}',
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
    notifyListeners();
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
          'Authorization': 'TOKEN ${_user!.getToken()}',
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
          'Authorization': 'TOKEN ${_user!.getToken()}',
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
          'Authorization': 'TOKEN ${_user!.getToken()}',
        },
        body: json.encode(task),
      );
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> updateTask(int id) async {
    Task existingTask = getTaskById(id);
    try {
      var url = Uri.parse('${domain}task-list/$id/update-task/');
      Map<String, dynamic> task = {
        'id': existingTask.id,
        'task': existingTask.task,
        'iscomplete': existingTask.iscomplete,
        'isfavorite': existingTask.isfavorite,
      };

      await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'TOKEN ${_user!.getToken()}',
        },
        body: json.encode(task),
      );
    } catch (error) {
      throw error.toString();
    }
  }
}
