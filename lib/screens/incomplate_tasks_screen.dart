// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:study_planner/screens/task_detail_screen.dart';
import '../providers/task_provider.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';

class IncompletedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: taskProvider.tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Text(
                    "No tasks available!",
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[200] : Color(0xFF1A237E),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Add new tasks to stay organized.",
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Color(0xFF757575),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                // فلترة المهام لتكون فقط المهام غير المكتملة
                itemCount: taskProvider.tasks
                    .where((task) => !task.isCompleted)
                    .length,
                itemBuilder: (context, index) {
                  // جلب المهام غير المكتملة فقط
                  final incompleteTasks = taskProvider.tasks
                      .where((task) => !task.isCompleted)
                      .toList();
                  final task = incompleteTasks[index];

                  final currentDateTime = DateTime.now();
                  // التحقق مما إذا كانت المهمة منتهية بناءً على التاريخ والوقت
                  final isOverdue =
                      task.date != null && task.date!.isBefore(currentDateTime);
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: isOverdue
                        ? Colors.red[700]
                        : (isDarkMode ? Color(0xFF424242) : Colors.white),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      title: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TaskDetailScreen(task: task),
                            ),
                          );
                        },
                        child: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? Colors.grey[300]
                                : Color(0xFF283593),
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(
                            task.description != null
                                ? (task.description!.length > 50
                                    ? "${task.description!.substring(0, 50)}..."
                                    : task.description!)
                                : "",
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Color(0xFF757575),
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (task.date != null)
                            Text(
                              "Date: ${task.date!.day}/${task.date!.month}/${task.date!.year} | Time: ${DateFormat('h:mm a').format(task.date!)}",
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Color(0xFF757575),
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          if (task.priority != null)
                            Text(
                              "Priority: ${task.priority}",
                              style: TextStyle(
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.check_circle,
                              color: task.isCompleted
                                  ? Colors.green
                                  : (isDarkMode
                                      ? Colors.grey[300]
                                      : Color(0xFF1A237E)),
                            ),
                            onPressed: () {
                              // تغيير حالة isCompleted عند الضغط على الزر
                              taskProvider.updateTaskStatus(task, true);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit,
                                color: isDarkMode
                                    ? Colors.grey[300]
                                    : Color(0xFF1A237E)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditTaskScreen(
                                    task: task,
                                    index: index,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Color(0xFFFF7043)),
                            onPressed: () {
                              _confirmDelete(context, taskProvider, index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isDarkMode ? Color(0xFF283593) : Color(0xFF1A237E),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, TaskProvider taskProvider, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              taskProvider.removeTask(index);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
