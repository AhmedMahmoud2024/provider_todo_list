import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider_todo_list/data/models/task_model.dart';

class TaskNotifier extends Notifier<List<TaskModel>> {
  
  @override   //buil same initstate
  List<TaskModel> build() =>[];

 void addTask(String title){
 if(title.trim().isEmpty) return;
 final newTask=TaskModel(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
   title: title.trim()
   );
 state=[...state,newTask];
 }

  void toggleTaskStatus(String id){
   state=[
    for(final task in state)
    if(task.id==id)
    task.copyWith(isDone: ! task.isDone)
    else
    task
   ];
}

void updateTaskTitle(String id,String newTitle){
  if(newTitle.trim().isEmpty) return;
  state=[
    for (final task in state)
    if(task.id==id)
    task.copyWith(title:newTitle.trim())
    else task
  ];
}

void deleteTask(String id){
state=state.where((task)=>
task.id != id
).toList();
}
}