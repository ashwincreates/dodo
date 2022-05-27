import 'package:flutter/cupertino.dart';
import 'package:todo/models/collection.dart';
import 'package:todo/util/db.dart';

class CollectionProvider extends ChangeNotifier {
	final List<Collection> _collections = [];

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

	insertcollection(String title) {
		debugPrint("collection created");
		DB db = DB();
		Collection col = Collection(
				text: title,
				date: DateTime.now(),
		);
		db.insertCollection(col);
		_collections.add(col);
		notifyListeners();
	}

}
