import 'package:flutter_test/flutter_test.dart';
import 'package:provider_todo_list/data/models/updated_task_model.dart';
// اعمل import للـ TaskModel بتاعك هنا

void main() {
  group('TaskModel Unit Tests', () {
    test('should correctly convert to and from Json with location fields', () {
      // 1. Arrange: عمل كائن يحتوي على إحداثيات
      final task = UpdatedTaskModel(
        id: '1',
        title: 'شراء الدواء',
        description: 'من صيدلية العزبي',
        latitude: 30.0444,
        longitude: 31.2357,
        locationName: 'وسط البلد، القاهرة',
      );

      // 2. Act: تحويله لـ JSON ثم إعادته لـ Model
      final json = task.toJson();
      final result = UpdatedTaskModel.fromJson(json);

      // 3. Assert: التأكد إن البيانات رجعت بالظبط زي ما كانت
      expect(result.latitude, 30.0444);
      expect(result.locationName, 'وسط البلد، القاهرة');
      expect(result.isDone, false);
    });
  });
}