import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_todo_list/data/providers/todo_provider.dart';
import 'package:provider_todo_list/presentation/screens/todo_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context)=>TodoProvider(),
      child: MaterialApp(
        title: 'Provider todo list',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: TodoListScreen()
      ),
    );
  }
}
