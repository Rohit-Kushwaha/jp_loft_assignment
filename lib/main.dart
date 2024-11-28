import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/repo/repo.dart';
import 'package:todo_app/res/string_manager.dart';
import 'package:todo_app/view/home.dart';
import 'package:todo_app/viewmodel/bloc/task_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.todoApp,
      home: BlocProvider(
        create: (context) => TaskBloc(TaskRepository())..add(LoadTasks()),
        child: const HomeScreen(),
      ),
    );
  }
}
