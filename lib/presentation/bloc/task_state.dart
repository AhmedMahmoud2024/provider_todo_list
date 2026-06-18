import 'package:provider_todo_list/data/models/task_model.dart';

sealed class TaskState {}
class TaskInitial extends TaskState{}
class TaskLoading extends TaskState{}
class TaskLoaded extends TaskState{
final List<TaskModel>tasks;
TaskLoaded(this.tasks);
}
class TaskError extends TaskState{
  final String message;
  TaskError(this.message);
}