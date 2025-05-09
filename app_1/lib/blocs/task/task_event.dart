part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent {
  final String userId;

  const LoadTasks(this.userId);

  @override
  List<Object> get props => [userId];
}

class AddTask extends TaskEvent {
  final Task task;

  const AddTask(this.task);

  @override
  List<Object> get props => [task];
}

class UpdateTask extends TaskEvent {
  final Task task;

  const UpdateTask(this.task);

  @override
  List<Object> get props => [task];
}

class DeleteTask extends TaskEvent {
  final String taskId;
  final String userId;

  const DeleteTask(this.taskId, this.userId);

  @override
  List<Object> get props => [taskId, userId];
}

class SearchTasks extends TaskEvent {
  final String query;

  const SearchTasks(this.query);

  @override
  List<Object> get props => [query];
}

class FilterTasks extends TaskEvent {
  final String status;
  final int priority;
  final String category;
  final bool completed;

  const FilterTasks({
    this.status = '',
    this.priority = 0,
    this.category = '',
    this.completed = false,
  });

  @override
  List<Object> get props => [status, priority, category, completed];
}