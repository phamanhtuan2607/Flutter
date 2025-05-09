// lib/screens/task_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/task/task_bloc.dart';
import '../models/task.dart';
import '../screens/task_edit_screen.dart';
import '../screens/task_kanban_screen.dart';
import '../screens/task_stats_screen.dart';
import '../widgets/task_item.dart';

class TaskListScreen extends StatefulWidget {
  final String user;

  const TaskListScreen({required this.user, super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasks(widget.user));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý công việc'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text("Xác nhận đăng xuất"),
                    content: const Text("Bạn có chắc chắn muốn đăng xuất không?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop(); // Đóng dialog
                        },
                        child: const Text("Hủy"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop(); // Đóng dialog
                          context.read<AuthBloc>().add(LogoutRequested()); // Đăng xuất
                        },
                        child: const Text("Đăng xuất", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
          ),

        ],
      ),
      body: _buildCurrentScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskEditScreen(userId: widget.user),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Danh sách',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Kanban',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Thống kê',
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildTaskList();
      case 1:
        return TaskKanbanScreen(userId: widget.user);
      case 2:
        return TaskStatsScreen(userId: widget.user);
      default:
        return _buildTaskList();
    }
  }

  Widget _buildTaskList() {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TaskLoadSuccess) {
          return ListView.builder(
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];
              return TaskItem(
                task: task,
                onComplete: () {
                  final updatedTask = Task(
                    id: task.id,
                    title: task.title,
                    description: task.description,
                    status: task.completed ? 'To do' : 'Done',
                    priority: task.priority,
                    dueDate: task.dueDate,
                    createdAt: task.createdAt,
                    updatedAt: DateTime.now(),
                    assignedTo: task.assignedTo,
                    createdBy: task.createdBy,
                    category: task.category,
                    attachments: task.attachments,
                    completed: !task.completed,
                  );
                  context.read<TaskBloc>().add(UpdateTask(updatedTask));
                },
                onDelete: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: const Text("Xác nhận xóa"),
                        content: const Text("Bạn có chắc chắn muốn xóa công việc này không?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop(); // Đóng hộp thoại
                            },
                            child: const Text("Hủy"),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<TaskBloc>().add(DeleteTask(task.id, widget.user));
                              Navigator.of(dialogContext).pop(); // Đóng hộp thoại
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Đã xóa công việc")),
                              );
                            },
                            child: const Text("Xóa", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                },
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskEditScreen(
                        task: task,
                        userId: widget.user,
                      ),
                    ),
                  );
                },
              );
            },
          );
        } else if (state is TaskFailure) {
          return Center(child: Text('Lỗi: ${state.error}'));
        } else {
          return const Center(child: Text('Không có công việc nào'));
        }
      },
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final searchController = TextEditingController();
        return AlertDialog(
          title: const Text('Tìm kiếm công việc'),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(hintText: 'Nhập từ khóa'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                context.read<TaskBloc>().add(SearchTasks(searchController.text));
                Navigator.pop(context);
              },
              child: const Text('Tìm kiếm'),
            ),
          ],
        );
      },
    );
  }
}