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
  Future<void> toogleDone(String id) async {
    final t = _tasks.firstWhere((t) => t.id == id);
    t.isDone = !t.isDone;
    notifyListeners();
    await _persist();
  }
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
    await _persist();
  }
  List<TodoTask> tasksForDate(DateTime date) {
    return _tasks
        .where((t) =>
            t.date.year == date.year &&
            t.date.month == date.month &&
            t.date.day == date.day)
        .toList()
      ..sort((a, b) => a.time.compareTo(b.time));
  }

  List<TodoTask> tasksForProject(String projectName) {
    return _tasks.where((t) => t.projectName == projectName).toList();
  }
  //add nanti
  static String newId() => _uuid.v4();

  List<TodoTask> _seedTasks() {
    final today = DateTime.now();
    return [
      TodoTask(
        id: newId(),
        title: 'Review deck presentasi klien Q3',
        projectName: 'Kerja',
        Priority: taskPriority.tinggi,
        date: today,
        time:'09:30',
      )
      TodoTask(
        id: newId(),
        title: 'Beli bahan makanan dan Vitamin',
        projectName: 'Pribadi',
        Priority: taskPriority.sedang,
        date: today,
        time:'17:30',
      )
      TodoTask(
        id: newId(),
        title: 'WO',
        projectName: 'Kesehatan',
        Priority: taskPriority.rendah,
        date: today,
        time:'14:30',
      )
      TodoTask(
        id: newId(),
        title: 'Draft email rangkuman mingguan',
        projectName: 'Kerja',
        Priority: taskPriority.sedang,
        date: today,
        time:'19:30',
      )
    ];
  }
}