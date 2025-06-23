import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Task {
  final String id;
  final String title;
  final String time;
  final DateTime deadline;
  final bool isCompleted;
  final Color borderColor;
  final String description;

  Task({
    required this.id,
    required this.title,
    required this.time,
    required this.deadline,
    required this.isCompleted,
    required this.borderColor,
    required this.description,
  });

  Task copyWith({
    String? id,
    String? title,
    String? time,
    DateTime? deadline,
    bool? isCompleted,
    Color? borderColor,
    String? description,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
      borderColor: borderColor ?? this.borderColor,
      description: description ?? this.description,
    );
  }
}

class TaskService extends ChangeNotifier {
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;
  TaskService._internal();

  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'complete project proposal',
      time: '8:00 AM',
      deadline: DateTime(2025, 6, 24),
      isCompleted: false,
      borderColor: const Color(0xFF9C88FF),
      description: 'Complete the project proposal for the new client',
    ),
    Task(
      id: '2',
      title: 'Review team updates',
      time: '10:00 AM',
      deadline: DateTime(2025, 6, 23),
      isCompleted: false,
      borderColor: const Color(0xFFFFB366),
      description: 'Review the weekly team updates and provide feedback',
    ),
    Task(
      id: '3',
      title: 'Gym workout',
      time: '6:00 PM',
      deadline: DateTime(2025, 6, 23),
      isCompleted: true,
      borderColor: const Color(0xFF66D9EF),
      description: 'Complete the evening workout routine',
    ),
  ];

  List<Task> get allTasks => List.unmodifiable(_tasks);

  List<Task> get completedTasksList => _tasks.where((task) => task.isCompleted).toList();

  List<Task> get pendingTasksList => _tasks.where((task) => !task.isCompleted).toList();

  int get totalTasks => _tasks.length;

  int get completedTasks => _tasks.where((task) => task.isCompleted).length;

  int get pendingTasks => _tasks.where((task) => !task.isCompleted).length;

  List<Task> get dueTodayTasks {
    final today = DateTime.now();
    return _tasks.where((task) {
      return task.deadline.year == today.year &&
          task.deadline.month == today.month &&
          task.deadline.day == today.day;
    }).toList();
  }

  List<DateTime> get taskDates {
    final dates = _tasks.map((task) => DateTime(
      task.deadline.year,
      task.deadline.month,
      task.deadline.day,
    )).toSet().toList();
    dates.sort();
    return dates;
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  void toggleTaskCompletion(String taskId) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(isCompleted: !_tasks[index].isCompleted);
      notifyListeners();
    }
  }

  List<Task> searchTasks(String query) {
    if (query.isEmpty) return _tasks;
    return _tasks.where((task) => 
      task.title.toLowerCase().contains(query.toLowerCase()) ||
      task.description.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }
}