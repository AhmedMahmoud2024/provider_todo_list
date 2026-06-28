import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart'; // 🛰️ إضافة مكتبة الجيولكيتور هنا
import 'package:provider_todo_list/data/models/updated_task_model.dart';

class TasksNotifier extends StateNotifier<List<UpdatedTaskModel>> {
  static const _storageKey = 'cached_tasks';

  // 1️⃣ الـ Constructor المعدل
  TasksNotifier() : super([]) {
    // بنحمل التاسكات الأول، وبعد ما تخلص بنشغل الـ Geofencing فوراً
    loadTasksFromStorage().then((_) {
      startGeofencing(); 
    });
  }

  // 2️⃣ خاصية الـ Geofencing ومراقبة الموقع لحظياً
  void startGeofencing() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // التحديث يحصل كل ما تتحرك 10 متر
      ),
    ).listen((Position position) {
      _checkProximityToTasks(position);
    });
  }

  // 3️⃣ دالة فحص المسافة بينك وبين التاسكات
  void _checkProximityToTasks(Position currentPosition) {
    for (var task in state) {
      // بنفحص فقط المهام اللي لسه مخلصتش ومربوطة بإحداثيات
      if (!task.isDone && task.latitude != null && task.longitude != null) {
        
        // حساب المسافة بالمتر بين موقعك الحالي وموقع التاسك
        double distanceInMeters = Geolocator.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          task.latitude!,
          task.longitude!,
        );

        // 🎯 لو قربت منها وبقيت على بعد أقل من أو يساوي 200 متر
        if (distanceInMeters <= 200) {
          _triggerSmartNotification(task);
        }
      }
    }
  }

  // 4️⃣ دالة إطلاق التنبيه (تطبع حالياً في الـ Console للـ Web)
  void _triggerSmartNotification(UpdatedTaskModel task) {
    print("🚨 تنبيه ذكي: هندسة، أنت قريب جداً من موقع مهمة: ${task.title}");
  }

  // --- باقي الدالات القديمة زي ما هي بدون أي تغيير ---

  Future<void> loadTasksFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_storageKey);
      if (cachedData != null) {
        final List<dynamic> decodedList = jsonDecode(cachedData);
        state = decodedList.map((item) => UpdatedTaskModel.fromJson(item)).toList();
      }
    } catch (e) {
      print("Error loading tasks: $e");
    }
  }

  Future<void> addTask(UpdatedTaskModel task) async {
    final updatedTasks = [...state, task];
    state = updatedTasks;
    await _saveTasksToStorage(updatedTasks);
  }

  Future<void> toggleTaskStatus(String id) async {
    final updatedTasks = state.map((task) {
      if (task.id == id) {
        return task.copyWith(isDone: !task.isDone);
      }
      return task;
    }).toList();
    state = updatedTasks;
    await _saveTasksToStorage(updatedTasks);
  }

  Future<void> deleteTask(String id) async {
    final updatedTasks = state.where((task) => task.id != id).toList();
    state = updatedTasks;
    await _saveTasksToStorage(updatedTasks);
  }

  Future<void> updateTask(UpdatedTaskModel updatedTask) async {
    final updatedTasks = state.map((task) {
      return task.id == updatedTask.id ? updatedTask : task;
    }).toList();
    state = updatedTasks;
    await _saveTasksToStorage(updatedTasks);
  }

  Future<void> _saveTasksToStorage(List<UpdatedTaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = tasks.map((task) => task.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(encodedList));
  }
}

// الـ Provider اللي الشاشات بتسمعه ثابت زي ما هو
final tasksNotifierProvider = StateNotifierProvider<TasksNotifier, List<UpdatedTaskModel>>((ref) {
  return TasksNotifier();
});