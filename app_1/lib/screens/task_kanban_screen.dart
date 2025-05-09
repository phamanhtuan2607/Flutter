// lib/screens/task_kanban_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task/task_bloc.dart';
import '../models/task.dart';
import 'task_detail_screen.dart';

class TaskKanbanScreen extends StatelessWidget {
  final String userId;

  const TaskKanbanScreen({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is TaskLoadSuccess) {
          return _buildKanbanView(state.tasks);
        } else if (state is TaskFailure) {
          return Center(child: Text('Error: ${state.error}'));
        } else {
          return Center(child: Text('No tasks found'));
        }
      },
    );
  }

  Widget _buildKanbanView(List<Task> tasks) {
    final todoTasks = tasks.where((t) => t.status == 'To do').toList();
    final inProgressTasks = tasks.where((t) => t.status == 'In progress').toList();
    final doneTasks = tasks.where((t) => t.status == 'Done').toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Kanban Board'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'To Do (${todoTasks.length})'),
              Tab(text: 'In Progress (${inProgressTasks.length})'),
              Tab(text: 'Done (${doneTasks.length})'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildStatusColumn(todoTasks),
            _buildStatusColumn(inProgressTasks),
            _buildStatusColumn(doneTasks),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusColumn(List<Task> tasks) {
    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
            trailing: _buildPriorityIcon(task.priority),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailScreen(task: task),
                ),
              );
            },
            onLongPress: () {
              _showStatusChangeDialog(context, task);
            },
          ),
        );
      },
    );
  }

  Widget _buildPriorityIcon(int priority) {
    IconData icon;
    Color color;

    switch (priority) {
      case 3:
        icon = Icons.keyboard_arrow_up;
        color = Colors.red;
        break;
      case 2:
        icon = Icons.horizontal_rule;
        color = Colors.orange;
        break;
      default:
        icon = Icons.keyboard_arrow_down;
        color = Colors.green;
    }

    return Icon(icon, color: color);
  }

  void _showStatusChangeDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('To do'),
                onTap: () {
                  _updateTaskStatus(context, task, 'To do');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('In progress'),
                onTap: () {
                  _updateTaskStatus(context, task, 'In progress');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Done'),
                onTap: () {
                  _updateTaskStatus(context, task, 'Done');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateTaskStatus(BuildContext context, Task task, String newStatus) {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      status: newStatus,
      priority: task.priority,
      dueDate: task.dueDate,
      createdAt: task.createdAt,
      updatedAt: DateTime.now(),
      assignedTo: task.assignedTo,
      createdBy: task.createdBy,
      category: task.category,
      attachments: task.attachments,
      completed: newStatus == 'Done',
    );

    context.read<TaskBloc>().add(UpdateTask(updatedTask));
  }
}