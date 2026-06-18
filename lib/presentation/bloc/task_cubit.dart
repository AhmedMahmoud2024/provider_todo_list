import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider_todo_list/data/models/task_model.dart';
import 'package:provider_todo_list/presentation/bloc/task_state.dart';

class TaskCubit  extends Cubit<TaskState>{
final List<TaskModel> _tasks=[];

TaskCubit():super(TaskInitial());

void _refereshTasks(){
  emit(TaskLoading());
  emit(TaskLoaded(_tasks));
}


 void addTask(String title){
 if(title.trim().isEmpty) return;
 final newTodo=TaskModel(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
   title: title.trim()
   );
   _tasks.add(newTodo);
   _refereshTasks();
 }

 void toggleTaskStatus(String id){
final index=_tasks.indexWhere((task)=>task.id==id);
if(index!=-1){
  _tasks[index].isDone = !_tasks[index].isDone;
  _refereshTasks();
}
}

void updateTaskTitle(String id,String newTitle){
final index=_tasks.indexWhere((task)=>task.id==id);
if(index!=-1 && newTitle.trim().isNotEmpty){
  _tasks[index]=_tasks[index].copyWith(title: newTitle.trim());
  _refereshTasks();
}
}
void deleteTask(String id){
_tasks.removeWhere((task)=>task.id==id);
_refereshTasks();
}
}