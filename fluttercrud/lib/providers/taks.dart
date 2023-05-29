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

  void togolCompleteTask() {
    iscomplete = !iscomplete;
    notifyListeners();
  }

  void togolFavoriteTask() {
    isfavorite = !isfavorite;
    notifyListeners();
  }

  String get getTaskAsTitle {
    final int length = task.length > 25 ? 25 : task.length;
    return '${task.substring(0, length)}....';
  }
}
