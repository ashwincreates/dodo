class Todo {
	String text;
	bool completed;
	DateTime? date;
	int id;
	int collection;

	Todo({
		this.id = 0,
		required this.text,
		required this.completed,
		this.date,
		this.collection = -1,
	});

	get getText => text;
	get isMarked => completed;
	get getDate => date;

	set setText(String t) {
		text = t;
	}

	set setComplete(bool s) {
		completed = s;
	}

	set setDate(DateTime d) {
		date = d;
	}

	Map<String, dynamic> toMap() {
		return {
			'text': text,
			'date': date == null ? "" : date?.toIso8601String(),
			'completed': completed ? 1 : 0,
			'collection': collection
		};
	}

	@override
	String toString() {
		return 'Todo{id: $id, text: $text, date: $date, completed: $completed, collection: $collection}';
	}

}
