import 'package:flutter/foundation.dart';

class Task with ChangeNotifier {
  int id;
  String task;
  bool iscomplete;
  bool isfavorite;
  String created;
  String updated;

  Task({
    required this.id,
    required this.task,
    required this.iscomplete,
    required this.isfavorite,
    required this.created,
    required this.updated,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      task: json['task'],
      isfavorite: json['isfavorite'],
      iscomplete: json['iscomplete'],
      created: json['created'],
      updated: json['updated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task': task,
      'iscomplete': iscomplete,
      'isfavorite': isfavorite,
    };
  }

  void togolCompleteTask() {
    iscomplete = !iscomplete;
    notifyListeners();
  }

  void togolFavoriteTask() {
    isfavorite = !isfavorite;
    notifyListeners();
  }

  void setTask({String? task, bool? iscomplete, bool? isfavorite}) {
    this.task = task ?? this.task;
    this.iscomplete = iscomplete ?? this.iscomplete;
    this.isfavorite = isfavorite ?? this.isfavorite;
  }

  String get getTaskAsTitle {
    final int length = task.length > 25 ? 25 : task.length;
    if (length <= 25) {
      return task;
    }
    return '${task.substring(0, length)}...';
  }
}
