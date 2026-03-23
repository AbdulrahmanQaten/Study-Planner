// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, library_private_types_in_public_api

// screens/add_task_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _priority;
  String? _dateError;
  String? _timeError;

  void _saveTask() {
    setState(() {
      _dateError = _selectedDate == null ? 'Please select a date' : null;
      _timeError = _selectedTime == null ? 'Please select a time' : null;
    });

    if (_formKey.currentState!.validate() &&
        _dateError == null &&
        _timeError == null) {
      final dateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      final task = Task(
        title: _titleController.text,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
        date: dateTime,
        priority: _priority,
      );

      Provider.of<TaskProvider>(context, listen: false).addTask(task);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? Theme.of(context).appBarTheme.backgroundColor
            : Color(0xFF1A237E),
        title: Text('Add New Task', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  labelStyle: TextStyle(
                      color: isDarkMode ? Colors.grey[300] : Color(0xFF283593)),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            isDarkMode ? Color(0xFF283593) : Color(0xFF1A237E)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Task Description (Optional)',
                  labelStyle: TextStyle(
                      color: isDarkMode ? Colors.grey[300] : Color(0xFF283593)),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            isDarkMode ? Color(0xFF283593) : Color(0xFF1A237E)),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            _selectedDate == null
                                ? 'Select Date'
                                : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                            style: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey[300]
                                    : Color(0xFF283593)),
                          ),
                          trailing: Icon(Icons.calendar_today,
                              color: isDarkMode
                                  ? Colors.white70
                                  : Color(0xFF1A237E)),
                          onTap: _pickDate,
                        ),
                        if (_dateError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              _dateError!,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            _selectedTime == null
                                ? 'Select Time'
                                : '${_selectedTime!.hour}:${_selectedTime!.minute}',
                            style: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey[300]
                                    : Color(0xFF283593)),
                          ),
                          trailing: Icon(Icons.access_time,
                              color: isDarkMode
                                  ? Colors.white70
                                  : Color(0xFF1A237E)),
                          onTap: _pickTime,
                        ),
                        if (_timeError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              _timeError!,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _priority,
                hint: Text('Task Priority',
                    style: TextStyle(
                        color:
                            isDarkMode ? Colors.grey[300] : Color(0xFF283593))),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            isDarkMode ? Color(0xFF283593) : Color(0xFF1A237E)),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'High',
                    child: Text('High',
                        style: TextStyle(color: Color(0xFFFF7043))),
                  ),
                  DropdownMenuItem(
                    value: 'Medium',
                    child:
                        Text('Medium', style: TextStyle(color: Colors.orange)),
                  ),
                  DropdownMenuItem(
                    value: 'Low',
                    child: Text('Low', style: TextStyle(color: Colors.green)),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _priority = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a priority';
                  }
                  return null;
                },
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDarkMode ? Color(0xFF283593) : Color(0xFF1A237E),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _saveTask,
                  child: Text(
                    'Save Task',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateError = null;
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final now = DateTime.now();
      final selectedDate = DateTime(
          _selectedDate!.year, _selectedDate!.month, _selectedDate!.day);
      final currentDate = DateTime(now.year, now.month, now.day);

      if (selectedDate == currentDate &&
          (pickedTime.hour < now.hour ||
              (pickedTime.hour == now.hour &&
                  pickedTime.minute < now.minute))) {
        setState(() {
          _timeError = 'Please select a time in the future';
        });
      } else {
        setState(() {
          _selectedTime = pickedTime;
          _timeError = null;
        });
      }
    }
  }
}
