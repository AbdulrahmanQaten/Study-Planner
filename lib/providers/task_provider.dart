// providers/task_provider.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final List<Task> _complateTasks = [];
  Timer? _checkTaskTimer;

  // List<Task> get tasks => _tasks;

  List<Task> get tasks => _tasks.where((task) => !task.isCompleted).toList();
  List<Task> get complateTasks =>
      _tasks.where((task) => task.isCompleted).toList();
  List<Task> get completedTasks =>
      _tasks.where((task) => !task.isCompleted).toList();
  List<Task> get incompleteTasks =>
      complateTasks.where((task) => !task.isCompleted).toList();

  TaskProvider() {
    _startCheckingTasks();
    loadTasks();
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    saveTasks();
    notifyListeners();
  }

  void updateTask(int index, Task updatedTask) {
    _tasks[index] = updatedTask;
    saveTasks();
    notifyListeners();
  }

  void updateTaskStatus(Task task, bool isCompleted) {
    task.isCompleted = isCompleted;
    saveTasks();
    notifyListeners(); // تحديث الواجهة بعد التغيير
  }

  void _startCheckingTasks() {
    // التحقق من المهام كل دقيقة
    _checkTaskTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkOverdueTasks();
    });
  }

  void _checkOverdueTasks() {
    DateTime now = DateTime.now();
    bool hasOverdueTask = false;

    for (var task in _tasks) {
      // تحقق إذا كانت المهمة منتهية ولم يتم اكتمالها بعد
      if (task.date != null && task.date!.isBefore(now) && !task.isCompleted) {
        hasOverdueTask = true;
      }
    }
    if (hasOverdueTask) {
      notifyListeners();
    }
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks');

    if (tasksJson != null) {
      final List<dynamic> taskList = jsonDecode(tasksJson);
      _tasks = taskList.map((json) => Task.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await saveTasks();
    notifyListeners();
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String tasksJson =
        jsonEncode(_tasks.map((task) => task.toJson()).toList());
    await prefs.setString('tasks', tasksJson);
  }
}
