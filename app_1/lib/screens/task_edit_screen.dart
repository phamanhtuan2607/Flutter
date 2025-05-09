// lib/screens/task_edit_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task/task_bloc.dart';
import '../models/task.dart';

class TaskEditScreen extends StatefulWidget {
  final Task? task;
  final String userId;

  const TaskEditScreen({this.task, required this.userId, Key? key}) : super(key: key);

  @override
  _TaskEditScreenState createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _status;
  late int _priority;
  DateTime? _dueDate;
  late String _category;
  List<String> _attachments = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _status = widget.task?.status ?? 'To do';
    _priority = widget.task?.priority ?? 2;
    _dueDate = widget.task?.dueDate;
    _category = widget.task?.category ?? '';
    _attachments = widget.task?.attachments ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              DropdownButtonFormField<String>(
                value: _status,
                items: ['To do', 'In progress', 'Done', 'Cancelled']
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Status'),
              ),
              DropdownButtonFormField<int>(
                value: _priority,
                items: [1, 2, 3]
                    .map((priority) => DropdownMenuItem(
                  value: priority,
                  child: Text(_getPriorityText(priority)),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Priority'),
              ),
              ListTile(
                title: Text(_dueDate == null
                    ? 'Select Due Date'
                    : 'Due Date: ${_dueDate!.toString()}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _dueDate = selectedDate;
                    });
                  }
                },
              ),
              TextFormField(
                initialValue: _category,
                decoration: InputDecoration(labelText: 'Category'),
                onChanged: (value) {
                  _category = value;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final task = Task(
                      id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                      title: _titleController.text,
                      description: _descriptionController.text,
                      status: _status,
                      priority: _priority,
                      dueDate: _dueDate,
                      createdAt: widget.task?.createdAt ?? DateTime.now(),
                      updatedAt: DateTime.now(),
                      assignedTo: widget.task?.assignedTo,
                      createdBy: widget.userId,
                      category: _category.isNotEmpty ? _category : null,
                      attachments: _attachments.isNotEmpty ? _attachments : null,
                      completed: _status == 'Done',
                    );

                    if (widget.task == null) {
                      context.read<TaskBloc>().add(AddTask(task));
                    } else {
                      context.read<TaskBloc>().add(UpdateTask(task));
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPriorityText(int priority) {
    switch (priority) {
      case 3:
        return 'High';
      case 2:
        return 'Medium';
      case 1:
        return 'Low';
      default:
        return 'Unknown';
    }
  }
}