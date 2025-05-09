// lib/screens/task_stats_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task/task_bloc.dart';
import '../models/task.dart';

class TaskStatsScreen extends StatelessWidget {
  final String userId;

  const TaskStatsScreen({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoadSuccess) {
          return _buildStats(state.tasks);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildStats(List<Task> tasks) {
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((t) => t.completed).length;
    final highPriorityTasks = tasks.where((t) => t.priority == 3).length;
    final overdueTasks = tasks.where((t) =>
    t.dueDate != null &&
        t.dueDate!.isBefore(DateTime.now()) &&
        !t.completed).length;

    return Scaffold(
      appBar: AppBar(title: Text('Task Statistics')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatCard('Total Tasks', totalTasks.toString(), Icons.list),
            _buildStatCard('Completed', '$completedTasks/$totalTasks', Icons.check_circle),
            _buildStatCard('High Priority', highPriorityTasks.toString(), Icons.warning),
            _buildStatCard('Overdue', overdueTasks.toString(), Icons.timer_off),
            SizedBox(height: 20),
            _buildPriorityChart(tasks),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(title, style: TextStyle(fontSize: 18)),
        trailing: Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildPriorityChart(List<Task> tasks) {
    final low = tasks.where((t) => t.priority == 1).length;
    final medium = tasks.where((t) => t.priority == 2).length;
    final high = tasks.where((t) => t.priority == 3).length;

    return Column(
      children: [
        Text('Tasks by Priority', style: TextStyle(fontSize: 20)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildPriorityIndicator('Low', low, Colors.green),
            _buildPriorityIndicator('Medium', medium, Colors.orange),
            _buildPriorityIndicator('High', high, Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildPriorityIndicator(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: count * 10.0,
          color: color,
        ),
        Text('$label\n$count', textAlign: TextAlign.center),
      ],
    );
  }
}