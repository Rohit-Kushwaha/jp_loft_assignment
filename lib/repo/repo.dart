import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

import 'package:todo_app/model/task.dart';

class TaskRepository {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = '${documentsDirectory.path}/tasks.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            isCompleted INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final task = await db.query('tasks');
    return List.generate(task.length, (i) => Task.fromMap(task[i]));
  }

  Future<void> addTask(Task task) async {
    final db = await database;
    await db.insert('tasks', task.toMap());
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }
}
