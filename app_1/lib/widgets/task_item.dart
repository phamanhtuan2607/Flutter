// lib/widgets/task_item.dart
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../screens/task_detail_screen.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function()? onComplete;
  final Function()? onDelete;
  final Function()? onEdit;

  const TaskItem({
    required this.task,
    this.onComplete,
    this.onDelete,
    this.onEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: task.completed,
          onChanged: (value) {
            if (onComplete != null) onComplete!();
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description),
            const SizedBox(height: 4),
            Text(
              'Hạn: ${task.dueDate?.toString().substring(0, 10) ?? 'Không có hạn'}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Ưu tiên: ${_getPriorityText(task.priority)}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(task: task),
            ),
          );
        },
      ),
    );
  }

  String _getPriorityText(int priority) {
    switch (priority) {
      case 3:
        return 'Cao';
      case 2:
        return 'Trung bình';
      case 1:
        return 'Thấp';
      default:
        return 'Không xác định';
    }
  }
}