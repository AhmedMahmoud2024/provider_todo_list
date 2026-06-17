import 'package:flutter/material.dart';
import 'package:provider_todo_list/data/models/task_model.dart';
class TodoItem extends StatelessWidget{
  final TaskModel task;
  final Function(String) onEdit;
  const TodoItem({
  super.key,
  required this.task,
  required this.onEdit
  });
  
  @override
  Widget build(BuildContext context) {
    final textController=TextEditingController(text: task.title);
    return AnimatedContainer(
    duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(vertical: 4,horizontal: 16),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: Colors.grey.withOpacity(0.2)
        ),
        child: ListTile(
         
                 title: Text(
                    task.title,
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