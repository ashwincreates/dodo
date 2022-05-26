import 'package:flutter/cupertino.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/util/db.dart';

class TodoProvider extends ChangeNotifier {

	final List<Todo> _list = [];
	final List<TextEditingController> _controller = [];
	DateTime date = DateTime.now();

	TodoProvider() {
		DB db = DB();
		_list.clear();
		_controller.clear();
		db.fetchtodosByDate(date).then((value) {
			for (final todo in value) {
				var controller = TextEditingController(text: todo.text);
				_list.add(todo);
				_controller.add(controller);
			}
			notifyListeners();
		});	
	}

	setDate(DateTime d) {
		debugPrint(d.toString());
		date = d;
		updateFromDB(DB());
	}

	get list => _list;

	get controller => _controller;

	addItem() {
    Todo todo = Todo(text: "", completed: false, date: date);
		_controller.add(TextEditingController());
		_list.add(todo);
		notifyListeners();
	}

	deleteElement(int index) {
		DB db = DB();
		db.deleteTodo(_list[index]);
		debugPrint("remove element at $index");
		_list.removeAt(index);
		_controller.removeAt(index);
		updateFromDB(db);
	}

	updateTodo(int index, bool completed) {
		DB db = DB();
		_list[index].completed = completed;
		db.updateTodo(_list[index]);
	}

	save(int index, bool completed) {
		debugPrint("Index saved $index");
		debugPrint("List length ${_list.length}");
		var controller = _controller[index];
		_list[index].text = controller.text;
		_list[index].completed = completed;
		DB db = DB();
		if (_list[index].id == 0) {
			db.insertTodo(_list[index]);
			debugPrint("inserted into db");
		} else {
			db.updateTodo(_list[index]);
			debugPrint("updated into db");
		}
		updateFromDB(db);
	}

	updateFromDB(DB db) {
		_list.clear();
		_controller.clear();
		db.fetchtodosByDate(date).then((value) {
			for (final todo in value) {
				_list.add(todo);
				var controller = TextEditingController(text: todo.text);
				_controller.add(controller);
			}
			notifyListeners();
		});	
	}
}
