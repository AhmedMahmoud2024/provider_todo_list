import 'package:flutter/material.dart';
import 'package:provider_todo_list/data/models/todo_model.dart';
class TaskItem extends StatelessWidget{
  final TodoItemModel task;

  const TaskItem({
  super.key,
  required this.task,
  });
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
    duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(vertical: 4,horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2)
        ),
        child: ListTile(
         
                 title: Text(
                    task.title,
                 ),
               
        ),
    );
  }
}