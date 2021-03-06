import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/UI/note.dart';
import 'package:todo/models/todo_provider.dart';
import 'package:todo/UI/collection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Todo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MultiProvider(
						providers: [
							ChangeNotifierProvider(create: (context) => TodoProvider()),
						],
          child: const MyHomePage(),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  Future<Null> selectDate(BuildContext context) async {
    var provider = Provider.of<TodoProvider>(context, listen: false);
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: provider.date,
        firstDate: DateTime(2015, 1),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (picked != null && picked != provider.date) {
      provider.setDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(builder: (context, notes, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 50,
          actions: [
            IconButton(
              splashRadius: 25,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Collections()));
              },
              icon: const Icon(
                Icons.all_inbox,
                color: Colors.black38,
                size: 29,
              ),
            ),
            IconButton(
                splashRadius: 25,
                onPressed: () {
                  selectDate(context);
                },
                icon: const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.black38,
                  size: 29,
                ))
          ],
        ),
        body: const Note(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            var list = context.read<TodoProvider>();
            list.addItem();
          },
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
