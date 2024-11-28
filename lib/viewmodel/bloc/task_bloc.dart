import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/repo/repo.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc(this.repository) : super(TaskInitial()) {
    on<LoadTasks>((event, emit) async {
      emit(TaskLoading());
      try {
        final tasks = await repository.getTasks();
        emit(TaskLoaded(tasks));
      } catch (_) {
        emit(TaskError());
      }
    });

    on<AddTask>((event, emit) async {
      try {
        await repository.addTask(Task(title: event.title));
        add(LoadTasks());
      } catch (_) {
        emit(TaskError());
      }
    });

    on<DeleteTask>((event, emit) async {
      try {
        await repository.deleteTask(event.id);
        add(LoadTasks());
      } catch (_) {
        emit(TaskError());
      }
    });

    on<ToggleTaskCompletion>((event, emit) async {
      try {
        final updatedTask = Task(
          id: event.task.id,
          title: event.task.title,
          isCompleted: !event.task.isCompleted,
        );
        await repository.updateTask(updatedTask);
        add(LoadTasks());
      } catch (_) {
        emit(TaskError());
      }
    });
  }
}

