// lib/screens/task_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task/task_bloc.dart';
import '../models/task.dart';
import 'task_edit_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({required this.task, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskEditScreen(
                    task: task,
                    userId: task.createdBy,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              task.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Description: ${task.description}'),
            SizedBox(height: 8),
            Text('Status: ${task.status}'),
            SizedBox(height: 8),
            Text('Priority: ${_getPriorityText(task.priority)}'),
            SizedBox(height: 8),
            Text('Due Date: ${task.dueDate?.toString() ?? 'No deadline'}'),
            SizedBox(height: 8),
            Text('Created At: ${task.createdAt.toString()}'),
            SizedBox(height: 8),
            Text('Updated At: ${task.updatedAt.toString()}'),
            SizedBox(height: 8),
            Text('Assigned To: ${task.assignedTo ?? 'Unassigned'}'),
            SizedBox(height: 8),
            Text('Category: ${task.category ?? 'Uncategorized'}'),
            SizedBox(height: 16),
            if (task.attachments != null && task.attachments!.isNotEmpty) ...[
              Text('Attachments:', style: TextStyle(fontWeight: FontWeight.bold)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: task.attachments!
                    .map((attachment) => Text('- $attachment'))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Xác nhận xóa"),
                content: Text("Bạn có chắc chắn muốn xóa công việc này không?"),
                actions: [
                  TextButton(
                    child: Text("Hủy"),
                    onPressed: () {
                      Navigator.of(context).pop(); // Đóng hộp thoại
                    },
                  ),
                  TextButton(
                    child: Text("Xóa", style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      context.read<TaskBloc>().add(DeleteTask(task.id, task.createdBy));
                      Navigator.of(context).pop(); // Đóng hộp thoại
                      Navigator.of(context).pop(); // Quay lại màn hình trước
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.delete),
        backgroundColor: Colors.red,
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
