import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider_todo_list/presentation/screens/select_location_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:provider_todo_list/data/models/updated_task_model.dart';
import 'package:provider_todo_list/presentation/riverpod/tasks_notifier.dart';


class AddTaskScreen extends ConsumerStatefulWidget {
  final UpdatedTaskModel? taskToEdit;

  const AddTaskScreen({super.key, this.taskToEdit});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  LatLng? _pickedLocation;

  @override
  void initState() {
    super.initState();
    if (widget.taskToEdit != null) {
      _titleController.text = widget.taskToEdit!.title;
      _descController.text = widget.taskToEdit!.description;
      if (widget.taskToEdit!.latitude != null && widget.taskToEdit!.longitude != null) {
        _pickedLocation = LatLng(widget.taskToEdit!.latitude!, widget.taskToEdit!.longitude!);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskToEdit != null ? 'تعديل المهمة' : 'إضافة مهمة جديدة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'عنوان المهمة'),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'تفاصيل المهمة'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.map),
              label: Text(_pickedLocation == null 
                  ? 'ربط المهمة بموقع جغرافي' 
                  : 'تم تحديد الموقع بنجاح ✅'),
              onPressed: () async {
                final LatLng? location = await Navigator.push<LatLng>(
                  context,
                  MaterialPageRoute(builder: (context) => const SelectLocationScreen()),
                );
                if (location != null) {
                  setState(() => _pickedLocation = location);
                }
              },
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              onPressed: () async {
                if (_titleController.text.isEmpty) return;

                if (widget.taskToEdit != null) {
                  final updatedTask = widget.taskToEdit!.copyWith(
                    title: _titleController.text,
                    description: _descController.text,
                    latitude: _pickedLocation?.latitude,
                    longitude: _pickedLocation?.longitude,
                    locationName: _pickedLocation != null ? "موقع معدل" : null,
                  );
                  await ref.read(tasksNotifierProvider.notifier).updateTask(updatedTask);
                } else {
                  final newTask = UpdatedTaskModel(
                    id: const Uuid().v4(),
                    title: _titleController.text,
                    description: _descController.text,
                    latitude: _pickedLocation?.latitude,
                    longitude: _pickedLocation?.longitude,
                    locationName: _pickedLocation != null ? "موقع محدد" : null,
                    isDone: false,
                  );
                  await ref.read(tasksNotifierProvider.notifier).addTask(newTask);
                }

                if (mounted) Navigator.pop(context);
              },
              child: Text(widget.taskToEdit != null ? 'تحديث المهمة' : 'حفظ المهمة'),
            ),
          ],
        ),
      ),
    );
  }
}