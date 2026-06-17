import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_todo_list/data/providers/task_provider.dart';
import 'package:provider_todo_list/presentation/widgets/todo_item.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
   
   final todoProvider=context.watch<TaskProvider>();
   final todoList= todoProvider.todos;
   final inputController=TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Provider ToDo_List'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
    children: [
      Padding(padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child:TextField(
              controller: inputController,
              decoration: InputDecoration(
                hintText: 'Enter Your new Task',
                border: OutlineInputBorder()
              ),
            ) 
          ),
          const SizedBox(width: 12,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
             // maximumSize: const Size(60, 54)
            ),
            onPressed: (){
              if(inputController.text.isNotEmpty){
                context.read<TaskProvider>().addTask(inputController.text);
                inputController.clear();
              }
            },
           child: const Icon(Icons.add)
           )
        ],
      ),
      ),
      Expanded(
        child:todoList.isEmpty? const Center(child: Text('No Tasks Availabe yet',
        style: TextStyle(color: Colors.grey),
        ),)
        : ListView.builder(
          itemCount: todoList.length,
          itemBuilder:(context,index){
            final todo=todoList[index];
            return TodoItem(
              todo:todo
               );
          } 
          )
        )
    ],        
      ),
    );
  }
}