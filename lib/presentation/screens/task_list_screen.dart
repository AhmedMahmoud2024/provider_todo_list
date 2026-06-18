import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_todo_list/data/providers/task_provider.dart';
import 'package:provider_todo_list/presentation/widgets/task_item.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // الاستماع الديناميكي للمخزن لإعادة رسم الـ ListView فقط عند حدوث تغيير
    final taskProvider = context.watch<TaskProvider>();
    final taskList = taskProvider.tasks;
    final inputController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Your Tasks'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: taskList.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_turned_in_outlined, size: 70, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Your list is empty. Add some focus!',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                final task = taskList[index];
                return TaskItem(
                  task: task,
                  onToggle: () => taskProvider.toggleTaskStatus(task.id),
                  onDelete: () => taskProvider.deleteTask(task.id),
                  onEdit: (newTitle) => taskProvider.updateTaskTitle(task.id, newTitle),
                );
              },
            ),
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
                      // استدعاء صامت (read) لإصدار الأمر دون إعادة رسم زر الـ FAB نفسه
                      context.read<TaskProvider>().addTask(inputController.text);
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