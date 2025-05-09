// lib/blocs/task/task_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/task.dart';
import '../../database/database_helper.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final DatabaseHelper databaseHelper;

  TaskBloc({required this.databaseHelper}) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<SearchTasks>(_onSearchTasks);
    on<FilterTasks>(_onFilterTasks);
  }

  Future<void> _onLoadTasks(
      LoadTasks event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoading());
    try {
      final tasks = await databaseHelper.getTasksByUser(event.userId);
      emit(TaskLoadSuccess(tasks: tasks));
    } catch (e) {
      emit(TaskFailure(error: e.toString()));
    }
  }

  Future<void> _onAddTask(
      AddTask event,
      Emitter<TaskState> emit,
      ) async {
    try {
      await databaseHelper.createTask(event.task);
      final tasks = await databaseHelper.getTasksByUser(event.task.createdBy);
      emit(TaskLoadSuccess(tasks: tasks));
    } catch (e) {
      emit(TaskFailure(error: e.toString()));
    }
  }

  Future<void> _onUpdateTask(
      UpdateTask event,
      Emitter<TaskState> emit,
      ) async {
    try {
      await databaseHelper.updateTask(event.task);
      final tasks = await databaseHelper.getTasksByUser(event.task.createdBy);
      emit(TaskLoadSuccess(tasks: tasks));
    } catch (e) {
      emit(TaskFailure(error: e.toString()));
    }
  }

  Future<void> _onDeleteTask(
      DeleteTask event,
      Emitter<TaskState> emit,
      ) async {
    try {
      await databaseHelper.deleteTask(event.taskId);
      final tasks = await databaseHelper.getTasksByUser(event.userId);
      emit(TaskLoadSuccess(tasks: tasks));
    } catch (e) {
      emit(TaskFailure(error: e.toString()));
    }
  }

  Future<void> _onSearchTasks(
      SearchTasks event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoading());
    try {
      final results = await databaseHelper.searchTasks(event.query);
      emit(TaskLoadSuccess(tasks: results));
    } catch (e) {
      emit(TaskFailure(error: e.toString()));
    }
  }

  Future<void> _onFilterTasks(
      FilterTasks event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoading());
    try {
      final filteredTasks = await databaseHelper.filterTasks(
        status: event.status,
        priority: event.priority,
        category: event.category,
        completed: event.completed,
      );
      emit(TaskLoadSuccess(tasks: filteredTasks));
    } catch (e) {
      emit(TaskFailure(error: e.toString()));
    }
  }
}