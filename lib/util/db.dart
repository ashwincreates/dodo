import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/todo.dart';
import 'package:intl/intl.dart';

class DB {
	DB(); 

	Future<Database> open() async {
		WidgetsFlutterBinding.ensureInitialized();
		final database = openDatabase(
				join(await getDatabasesPath(), 'todos.db'),
				onCreate: ((db, version) {
					return db.execute(
							'CREATE TABLE IF NOT EXISTS todos(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT, date TEXT, completed INT)'
					);
				}),
				version: 1,
		);
		return database;
	}

	Future<void> insertTodo(Todo todo) async {
		final Database db = await open();

		await db.insert(
				'todos',
				todo.toMap(),
				conflictAlgorithm: ConflictAlgorithm.replace
		);
	}

	Future<void> updateTodo(Todo todo) async {
		final Database db = await open();

		await db.update(
			'todos',
			todo.toMap(),
			where: 'id = ?',
			whereArgs: [todo.id]
		);
	}

	Future<void> deleteTodo(Todo todo) async {
		final Database db = await open();

		await db.delete(
			'todos',
			where: 'id = ?',
			whereArgs: [todo.id]
		);
	}
	
	Future<List<Todo>> fetchtodos() async {
		final Database db = await open();
		final List<Map<String, dynamic>> list = await db.query('todos');
		return List.generate(list.length, (i) {
			return Todo(
					id: list[i]['id'],
					text: list[i]['text'],
					date: DateTime.parse(list[i]['date']),
					completed: list[i]['completed'] == 1 ? true : false
			);	
		});
	}

	Future<List<Todo>> fetchtodosByDate(DateTime d) async {
		final Database db = await open();
		String date = DateFormat('yyyy-MM-dd').format(d);
		final List<Map<String, dynamic>> list = await db.query(
				'todos',
				where: "date LIKE ?",
				whereArgs: ["%$date%"]
				);
		return List.generate(list.length, (i) {
			return Todo(
					id: list[i]['id'],
					text: list[i]['text'],
					date: DateTime.parse(list[i]['date']),
					completed: list[i]['completed'] == 1 ? true : false
			);	
		});
	}
}
