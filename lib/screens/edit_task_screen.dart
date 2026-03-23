// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, library_private_types_in_public_api, prefer_const_constructors_in_immutables

// screens/edit_task_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  final int index;

  EditTaskScreen({required this.task, required this.index});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _priority;
  String? _dateError;
  String? _timeError;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task.title;
    _descriptionController.text = widget.task.description ?? '';
    _selectedDate = widget.task.date ?? DateTime.now();
    _selectedTime = widget.task.date != null
        ? TimeOfDay(
            hour: widget.task.date!.hour, minute: widget.task.date!.minute)
        : TimeOfDay.now();
    _priority = widget.task.priority;
  }

  void _saveTask() {
    setState(() {
      _dateError = _selectedDate == null ? 'Please select a date' : null;
      _timeError = _selectedTime == null ? 'Please select a time' : null;
    });

    if (_formKey.currentState!.validate() &&
        _dateError == null &&
        _timeError == null) {
      final updatedDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      final updatedTask = Task(
        title: _titleController.text,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
        date: updatedDateTime,
        priority: _priority,
      );

      Provider.of<TaskProvider>(context, listen: false)
          .updateTask(widget.index, updatedTask);
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
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
      initialTime: _selectedTime ?? TimeOfDay.now(),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? Theme.of(context).appBarTheme.backgroundColor
            : Color(0xFF1A237E),
        title: Text('Edit Task', style: TextStyle(color: Colors.white)),
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
                      color: isDarkMode ? Colors.white70 : Color(0xFF283593)),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: isDarkMode ? Colors.white : Color(0xFF1A237E)),
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
                      color: isDarkMode ? Colors.white70 : Color(0xFF283593)),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: isDarkMode ? Colors.white : Color(0xFF1A237E)),
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
                                    ? Colors.white70
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
                                    ? Colors.white70
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
                            isDarkMode ? Colors.white70 : Color(0xFF283593))),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: isDarkMode ? Colors.white : Color(0xFF1A237E)),
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
                        isDarkMode ? Color(0xFF3949AB) : Color(0xFF1A237E),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _saveTask,
                  child: Text(
                    'Save Changes',
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
}
