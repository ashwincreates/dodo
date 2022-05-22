import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/models/todo.dart';

class Tile extends StatefulWidget {

	final Todo todo;
	final int index;
	final Function onDelete;
	final Function onSubmit;
	final TextEditingController controller;

	const Tile({Key? key,
		required this.todo,
		required this.onDelete,
		required this.onSubmit,
		required this.index,
		required this.controller
	}): super(key: key); 
	

	@override
	State<Tile> createState() => TileState();
}

class TileState extends State<Tile> {
	FocusNode focusNode = FocusNode();
	bool completed = false;
	bool wasCompleted = false;
	bool dirty = false;

	@override
	void initState() {
		super.initState();
		focusNode.addListener(onFocusChange);
		WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
			debugPrint(widget.todo.text);
			setState(() {
				widget.controller.text = widget.todo.text;
				completed = widget.todo.completed;
				wasCompleted = completed;
			});
		});
	}

	@override
	void dispose() {
		super.dispose();
		focusNode.removeListener(onFocusChange);
		focusNode.dispose();
	}

	onFocusChange() {
		if (focusNode.hasFocus && completed) {
			setState(() {
				wasCompleted = completed;
			  completed = false;
			});
		} else if (!focusNode.hasFocus && wasCompleted) {
			setState(() {
				completed = wasCompleted;
			});
		}
	}

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
				onHorizontalDragUpdate: (movement) {
					int sensitivity = 8;
					if (movement.delta.dx > sensitivity || movement.delta.dx < -sensitivity) {
						wasCompleted = false;
						completed = !completed;
						setState(() {});
						widget.onSubmit(widget.index, completed);
					}
				},
				child: SizedBox(
				height: 50,
				width: MediaQuery.of(context).size.width,
				child: RawKeyboardListener(
						focusNode: focusNode,
						onKey: (event) {
							if (event.logicalKey == LogicalKeyboardKey.backspace && widget.controller.text == "") {
								focusNode.unfocus();
								widget.onDelete(widget.index);
							}
						},
						child: TextField(
							decoration: const InputDecoration(
									border: InputBorder.none,
									hintText: "your todo"
							),
							style: TextStyle(
									fontSize: 22,
									fontWeight: FontWeight.w600,
									decoration: completed ? TextDecoration.lineThrough : TextDecoration.none,
									color: completed ? Colors.black45 : Colors.black,
							),
							controller: widget.controller,
							onChanged: (String? string) {
								dirty = true;
							},
							onSubmitted: (String? string) {
								if (dirty) {
									widget.onSubmit(widget.index, wasCompleted);
									dirty = false;
								}
							},
					),
				),
			)
		);
	}
}
