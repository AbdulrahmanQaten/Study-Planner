// models/task.dart
import 'package:flutter/material.dart';

class Task {
  String title;
  String? description;
  DateTime? date;
  TimeOfDay? time;
  String? priority;
  bool isCompleted;

  Task({
    required this.title,
    this.description,
    this.date,
    this.priority,
    this.isCompleted = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      priority: json['priority'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date?.toIso8601String(),
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }
}
