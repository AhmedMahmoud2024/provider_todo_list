import 'package:flutter/material.dart';
import 'package:provider_todo_list/data/models/task_model.dart';

class TaskProvider with ChangeNotifier {
final List<TaskModel> _tasks=[];
 List<TaskModel>  get tasks=>_tasks;

 void addTask(String title){
 if(title.trim().isEmpty) return;
 final newTodo=TaskModel(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
   title: title.trim()
   );
   _tasks.add(newTodo);
   notifyListeners();
 }
 
void toggleTaskStatus(String id){
final index=_tasks.indexWhere((task)=>task.id==id);
if(index!=-1){
  _tasks[index].isDone = !_tasks[index].isDone;
  notifyListeners();
}
}

void updateTaskTitle(String id,String newTitle){
final index=_tasks.indexWhere((task)=>task.id==id);
if(index!=-1 && newTitle.trim().isNotEmpty){
  _tasks[index]=_tasks[index].copyWith(title: newTitle.trim());
  notifyListeners();
}
}

void deleteTask(String id){
_tasks.removeWhere((task)=>task.id==id);
notifyListeners();
}
}