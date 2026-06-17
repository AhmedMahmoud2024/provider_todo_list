import 'package:flutter/material.dart';
import 'package:provider_todo_list/data/models/todo_model.dart';

class TodoProvider with ChangeNotifier {
final List<TodoItemModel> _todos=[];
 List<TodoItemModel>  get todos=>_todos;

 void addTodo(String title){
 if(title.trim().isEmpty) return;
 final newTodo=TodoItemModel(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
   title: title.trim()
   );
   _todos.add(newTodo);
   notifyListeners();
 }
}