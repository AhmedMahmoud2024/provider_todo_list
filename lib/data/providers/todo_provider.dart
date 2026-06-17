import 'package:flutter/material.dart';
import 'package:provider_todo_list/data/models/task_model.dart';

class TodoProvider with ChangeNotifier {
final List<TaskModel> _todos=[];
 List<TaskModel>  get todos=>_todos;

 void addTodo(String title){
 if(title.trim().isEmpty) return;
 final newTodo=TaskModel(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
   title: title.trim()
   );
   _todos.add(newTodo);
   notifyListeners();
 }
}