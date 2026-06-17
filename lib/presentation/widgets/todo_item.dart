import 'package:flutter/material.dart';
import 'package:provider_todo_list/data/models/task_model.dart';
class TodoItem extends StatelessWidget{
  final TaskModel todo;

  const TodoItem({
  super.key,
  required this.todo,
  });
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
    duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(vertical: 4,horizontal: 16),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: Colors.grey.withOpacity(0.2)
        ),
        child: ListTile(
         
                 title: Text(
                    todo.title,
                 ),
               
        ),
    );
  }
}