import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/UI/tile.dart';
import 'package:todo/models/todo_provider.dart';

class Note extends StatefulWidget {
  const Note({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NoteState();
}

class NoteState extends State<Note> {
  @override
  void initState() {
    super.initState();
  }

  deleteElement(int index) {
    var list = context.read<TodoProvider>();
    list.deleteElement(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
          child: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<TodoProvider>(
                    builder: (context, todo, child) {
                      return Text(
                        DateFormat('EEEE').format(todo.date),
                        style: const TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 18,
                        ),
                      );
                    },
                  ),
                  Consumer<TodoProvider>(
                    builder: (context, todo, child) {
                      var date = todo.date;
                      return Text(
                        "${date.day} ${DateFormat('MMM').format(date)} ${date.year}",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 32,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Consumer<TodoProvider>(
                      builder: (context, todo, child) => ListView.builder(
                          padding: const EdgeInsets.all(16),
                          shrinkWrap: true,
                          itemCount: todo.list.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Tile(
                              onSubmit: todo.save,
                              onUpdate: todo.updateTodo,
                              todo: todo.list[index],
                              onDelete: deleteElement,
                              index: index,
                              controller: todo.controller[index],
                            );
                          }))),
            ),
          ],
        ),
      ])),
    );
  }
}
