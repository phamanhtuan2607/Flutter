// lib/blocs/task/task_state.dart
part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoadSuccess extends TaskState {
  final List<Task> tasks;

  const TaskLoadSuccess({required this.tasks});

  @override
  List<Object> get props => [tasks];
}

class TaskFailure extends TaskState {
  final String error;

  const TaskFailure({required this.error});

  @override
  List<Object> get props => [error];
}