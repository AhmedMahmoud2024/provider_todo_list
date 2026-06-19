import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider_todo_list/presentation/widgets/task_item.dart';
import '../riverpod/task_notifier.dart';
class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
  
  final taskList=ref.watch(taskProvider);
    final inputController = TextEditingController();
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Your Tasks'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
     body: taskList.isEmpty?const Center(
      child: Text('No Tasks Found.Create one!',
      style: TextStyle(
        color: Colors.grey
      ),
      ),
     )
          :  ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                final task = taskList[index];
                return TaskItem(
                  task: task,
                  onToggle: () => ref.read(taskProvider.notifier).toggleTaskStatus(task.id),
                  onDelete: () => ref.read(taskProvider.notifier).deleteTask(task.id),
                  onEdit: (newTitle) => ref.read(taskProvider.notifier).updateTaskTitle(task.id, newTitle),
                );
              },
            )
          

          ,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (ctx) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                top: 24, left: 24, right: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Add New Task', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: inputController,
                    decoration: const InputDecoration(
                      labelText: 'What needs to be done?',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ref.read(taskProvider.notifier).addTask(inputController.text);
                      Navigator.pop(ctx);
                    },
                    child: const Text('Save Task', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}