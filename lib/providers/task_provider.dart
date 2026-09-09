import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';

const_prefsKey = 'lisaps_task_v1';
const _uuid = Uuid();

class TaskProvider extends ChangeNotifier {
  List<TodoTask> _tasks = [];
  bool _isLoaded = false;

  List<TodoTask> get tasks => Lists.unmodifiable(_tasks);
  bool get isLoaded => _isLoaded;

  List<String> get projectNames =>
      _tasks.map((t) => t.projectName).toSet().toList()..sort();
  
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw ==null) {
      _tasks = _seedTasks();
      await _persist();
    } else {
      final list = jsonDecode(raw) as List;
      _tasks = list
          .map((e) => TodoTask.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(_tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_prefsKey, raw);
  }
  Future<void> addTask(TodoTask task) async {
    _tasks.add(task);
    notifyListeners();
    await _persist();
  }
  //add nanti
}