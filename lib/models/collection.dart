class Collection {
	int id;
	String text;
	DateTime date;

	Collection({
		this.id = 0,
		required this.text,
		required this.date,
	});

	get getText => text;
	get getDate => date;

	set setText(String t) {
		text = t;
	}

	set setDate(DateTime d) {
		date = d;
	}

	Map<String, dynamic> toMap() {
		return {
			'title': text,
			'date': date.toIso8601String(),
		};
	}

	@override
	String toString() {
		return 'Collection{id: $id, text: $text, date: $date}';
	}

}
