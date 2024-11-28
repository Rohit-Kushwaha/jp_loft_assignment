import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/res/string_manager.dart';
import 'package:todo_app/viewmodel/bloc/task_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text(AppStrings.todoApp)),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            return _userData(state);
          } else if (state is TaskError) {
            return const Center(child: Text(AppStrings.errorLoadingTasks));
          }
          return const Center(child: Text(AppStrings.noTaskYet));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _dialog(context);
        },
      ),
    );
  }

  ListView _userData(TaskLoaded state) {
    return ListView.builder(
      itemCount: state.tasks.length,
      itemBuilder: (context, index) {
        final task = state.tasks[index];
        return GestureDetector(
          onTap: () {
            context.read<TaskBloc>().add(ToggleTaskCompletion(task));
          },
          child: ListTile(
            title: Text(
              task.title,
              style: const TextStyle(),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check,
                      color: task.isCompleted ? Colors.green : Colors.white),
                  onPressed: null,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      context.read<TaskBloc>().add(DeleteTask(task.id!)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> _dialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(AppStrings.addTask),
          content: TextField(controller: _controller),
          actions: [
            TextButton(
              onPressed: () {
                final title = _controller.text;
                if (title.isNotEmpty) {
                  debugPrint(title);
                  context.read<TaskBloc>().add(AddTask(title));
                }
                _controller.clear();
                Navigator.pop(context);
              },
              child: const Text(AppStrings.add),
            ),
          ],
        );
      },
    );
  }
}
