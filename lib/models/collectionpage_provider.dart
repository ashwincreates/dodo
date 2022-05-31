import 'package:flutter/cupertino.dart';
import 'package:todo/models/collection.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/util/db.dart';

class CollectionPageProvider extends ChangeNotifier {

	final Collection collection;
	final List<Todo> _list = [];
	final List<TextEditingController> _controller = [];
	DateTime date = DateTime.now();

	get list => _list;
	get controllers => _controller;

	CollectionPageProvider({required this.collection}) {
		DB db = DB();
		updateFromDB(db);
	}

	updateTodo(int index, bool completed) {
		DB db = DB();
		_list[index].completed = completed;
		db.updateTodo(_list[index]);
	}

	save(int index, bool completed) {
		var controller = _controller[index];
		_list[index].text = controller.text;
		_list[index].completed = completed;
		DB db = DB();
		if (_list[index].id == 0) {
			db.insertTodo(_list[index]);
		} else {
			db.updateTodo(_list[index]);
		}
		updateFromDB(db);
	}

	deleteElement(int index) {
		DB db = DB();
		db.deleteTodo(_list[index]);
		debugPrint("remove element at $index");
		_list.removeAt(index);
		_controller.removeAt(index);
		updateFromDB(db);
	}

	addItem() {
    Todo todo = Todo(text: "", completed: false, collection: collection.id);
		_controller.add(TextEditingController());
		_list.add(todo);
		notifyListeners();
	}

	updateCollection(String string) {
		DB db = DB();
		collection.text = string;
		db.updateCollection(collection);
		notifyListeners();
	}

	updateFromDB(DB db) {
		_list.clear();
		_controller.clear();
		db.fetchtodosByCollection(collection.id).then((value) {
			for (final todo in value) {
				_list.add(todo);
				var controller = TextEditingController(text: todo.text);
				_controller.add(controller);
			}
			notifyListeners();
		});	
	}

}
