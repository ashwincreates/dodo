import 'package:flutter/cupertino.dart';
import 'package:todo/models/collection.dart';
import 'package:todo/util/db.dart';

class CollectionProvider extends ChangeNotifier {
	final List<Collection> _collections = [];
	List<bool> _selectedList = [];

	CollectionProvider() {
		DB db = DB();
		_collections.clear();
		db.fetchcollections().then((value) {
			for (final collection in value) {
				_collections.add(collection);
			}
			notifyListeners();
		});
	}

	get collection => _collections;

	get selection => _selectedList;

	toggle(int index) {
		_selectedList[index] = !_selectedList[index];
		notifyListeners();
	}

	initSelection() {
		_selectedList = List.filled(_collections.length, false);
		notifyListeners();
	}

	deleteCollections() {
		List<Collection> list = [];
		for (int i = 0; i < _collections.length; i++) {
			if (_selectedList[i]) {
				list.add(_collections[i]);
			}
		}
		DB db = DB();
		db.deletecollections(list).then((_) {
			updateCollections(db);
		});
	}

	updateCollections(DB db) {
		_collections.clear();
		db.fetchcollections().then((value) {
			for (final collection in value) {
				_collections.add(collection);
			}
			notifyListeners();
		});

	}

	insertcollection(String title) {
		debugPrint("collection created");
		DB db = DB();
		Collection col = Collection(
				text: title,
				date: DateTime.now(),
		);
		db.insertCollection(col).then((value){
			updateCollections(db);
		});
	}

}
