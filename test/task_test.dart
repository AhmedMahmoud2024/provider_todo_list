import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class TaskNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => []; 
  void addTask(String task) {
    state = [...state, task];
  }

  void deleteTask(String task) {
    state = state.where((t) => t != task).toList(); 
  }
}

final taskProvider = NotifierProvider<TaskNotifier, List<String>>(() {
  return TaskNotifier();
});

void main() {
  group('TaskNotifier Unit Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state should be an empty list', () {
      final initialState = container.read(taskProvider);
      expect(initialState, isEmpty);
    });

    test('Adding a task should update the state correctly', () {

      container.read(taskProvider.notifier).addTask('Learn Unit Testing');

   final updatedState = container.read(taskProvider);
      expect(updatedState, contains('Learn Unit Testing'));
      expect(updatedState.length, 1);
    });

    test('Deleting a task should remove it from the state', () {
      container.read(taskProvider.notifier).addTask('Task to delete');
      
      container.read(taskProvider.notifier).deleteTask('Task to delete');

      final finalState = container.read(taskProvider);
      expect(finalState, isNot(contains('Task to delete')));
      expect(finalState, isEmpty);
    });
  });
}