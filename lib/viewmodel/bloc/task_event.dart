part of 'task_bloc.dart';

@immutable
sealed class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final String title;
  AddTask(this.title);
}

class DeleteTask extends TaskEvent {
  final int id;
  DeleteTask(this.id);
}

class ToggleTaskCompletion extends TaskEvent {
  final Task task;
  ToggleTaskCompletion(this.task);
}
