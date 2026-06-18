import 'package:flutter/material.dart';
import 'package:provider_todo_list/data/models/task_model.dart';
class TodoItem extends StatelessWidget{
  final TaskModel task;
  final VoidCallback onDelete;
   final VoidCallback onToggle;
  final Function(String) onEdit;
  const TodoItem({
  super.key,
  required this.task,
  required this.onEdit,
  required this.onToggle,
  required this.onDelete,
  });
  
  @override
  Widget build(BuildContext context) {
    final textController=TextEditingController(text: task.title);
    return AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    curve: Curves.bounceIn,
        margin: EdgeInsets.symmetric(vertical: 4,horizontal: 16),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: task.isDone?Colors.deepPurple.withOpacity(0.05)
          : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)
            )
          ]
        ),
        child: ListTile(
             leading: Checkbox
             (value: task.isDone,
              onChanged: (_)=>onToggle(),
              activeColor: Colors.deepPurple,
              ),         
                 title: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: task.isDone? TextDecoration.lineThrough :null,
                      color: task.isDone? Colors.grey:Colors.black87,
                    ),
                 ),
               trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed:(){
                       showDialog(
                      context: context,
                      builder: (ctx) =>AlertDialog(
                        title: Text('Edit Task'),
                        content: TextField(
                          controller:textController,
                          autofocus: true,
                        ),
                        actions: [
                          TextButton(
                            onPressed:()=> Navigator.pop(ctx),
                             child: const Text('Cancel')
                             ),
                             ElevatedButton(
                              onPressed: (){
                                onEdit(textController.text);
                                Navigator.pop(ctx);
                              },
                               child: const Text('Save')
                               ),
                              IconButton(
                                onPressed: onDelete,
                                 icon: const Icon(Icons.delete_outline,
                                 color: Colors.redAccent,
                                 )
                                 ) 
                        ],
                      ) ,
                    );
                    }
                    ,
                     icon: const Icon(Icons.edit_outlined,
                     color: Colors.blue
                     ,)
                     )
                ],
               ),
        ),
    );
  }
}