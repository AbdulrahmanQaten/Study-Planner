// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, library_private_types_in_public_api, prefer_const_constructors_in_immutables

// screens/task_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  TaskDetailScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        backgroundColor: isDarkMode
            ? Theme.of(context).appBarTheme.backgroundColor
            : Color(0xFF1A237E),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode ? Color(0xFF424242) : Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  if (!isDarkMode)
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Color(0xFF283593),
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  SizedBox(height: 20),
                  if (task.description != null)
                    Text(
                      task.description!,
                      style: TextStyle(
                        fontSize: 18,
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  SizedBox(height: 20),
                  if (task.date != null)
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: isDarkMode
                                ? Colors.white70
                                : Color(0xFF283593)),
                        SizedBox(width: 8),
                        Text(
                          "Date: ${task.date!.day}/${task.date!.month}/${task.date!.year}",
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                isDarkMode ? Colors.white54 : Color(0xFF757575),
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 10),
                  if (task.date != null)
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            color: isDarkMode
                                ? Colors.white70
                                : Color(0xFF283593)),
                        SizedBox(width: 8),
                        Text(
                          "Time: ${DateFormat('h:mm a').format(task.date!)}",
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                isDarkMode ? Colors.white54 : Color(0xFF757575),
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 20),
                  if (task.priority != null)
                    Row(
                      children: [
                        Icon(Icons.flag,
                            color: isDarkMode
                                ? Colors.white70
                                : Color(0xFF283593)),
                        SizedBox(width: 8),
                        Text(
                          "Priority: ${task.priority}",
                          style: TextStyle(
                            fontSize: 16,
                            color: task.priority == "High"
                                ? Color(0xFFFF7043)
                                : task.priority == "Medium"
                                    ? Colors.orange[300]
                                    : Colors.green,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.check_circle,
                          color:
                              isDarkMode ? Colors.white70 : Color(0xFF283593)),
                      SizedBox(width: 8),
                      Text(
                        task.isCompleted ? "Complated" : "Incomplate",
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              isDarkMode ? Colors.white54 : Color(0xFF757575),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
