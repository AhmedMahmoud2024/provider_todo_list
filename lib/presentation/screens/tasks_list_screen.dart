import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart'; // 🛰️ ضف الـ import ده هنا
import 'package:provider_todo_list/presentation/riverpod/tasks_notifier.dart';
import 'package:provider_todo_list/presentation/screens/add_task-screen.dart';


class TasksListScreen extends ConsumerWidget {
  const TasksListScreen({super.key});

  // 🧠 دالة فحص المسافة وإظهار الـ Alert للمستخدم على الشاشة
  void _checkGeofencingInUI(BuildContext context, List tasks) {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      for (var task in tasks) {
        if (!task.isDone && task.latitude != null && task.longitude != null) {
          double distance = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            task.latitude!,
            task.longitude!,
          );

          // 🚨 لو المسافة أقل من 200 متر، اظهر نافذة منبثقة فوراً في الـ UI
          if (distance <= 200) {
            showDialog(
              context: context,
              barrierDismissible: false, // لازم يضغط قفل عشان تقفل
              builder: (context) => AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.add_alert, color: Colors.red),
                    SizedBox(width: 8),
                    Text('تنبيه جغرافي ذكي 🚨'),
                  ],
                ),
                content: Text('مهندس، أنت على بعد ${distance.toStringAsFixed(0)} متر فقط من موقع مهمة: "${task.title}"!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('فهمت'),
                  ),
                ],
              ),
            );
            break; // عشان ما يكررش الـ Dialog كذا مرة ورا بعض
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksNotifierProvider);

    // 🔥 تشغيل الفحص والربط بالـ UI بمجرد بناء الشاشة وجود داتا
    if (tasks.isNotEmpty) {
      _checkGeofencingInUI(context, tasks);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('مهامي الجغرافية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTaskScreen()),
              );
            },
          )
        ],
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                'لا توجد مهام حالياً، اضغط + لإضافة مهمة',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Dismissible(
                  key: Key(task.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    ref.read(tasksNotifierProvider.notifier).deleteTask(task.id);
                  },
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(task.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddTaskScreen(taskToEdit: task),
                              ),
                            );
                          },
                        ),
                        Checkbox(
                          value: task.isDone,
                          onChanged: (_) => ref
                              .read(tasksNotifierProvider.notifier)
                              .toggleTaskStatus(task.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}