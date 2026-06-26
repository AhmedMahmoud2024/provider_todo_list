import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:provider_todo_list/data/services/location_service.dart';


// 1. إنشاء كلاس محاكاة للـ Platform الخاص بالـ Geolocator
class MockGeolocatorPlatform extends MockPlatformInterfaceMixin
    implements GeolocatorPlatform {
  @override
  Future<bool> isLocationServiceEnabled() async => true;

  @override
  Future<LocationPermission> checkPermission() async => LocationPermission.whileInUse;

  @override
  Future<LocationPermission> requestPermission() async => LocationPermission.whileInUse;

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    // هنا بنرجع موقع وهمي ثابت (مثلاً إحداثيات القاهرة) عشان التيست يتأكد إن السيرفيس بتقرأه صح
    return Position(
      latitude: 30.0444,
      longitude: 31.2357,
      timestamp: DateTime.now(),
      accuracy: 1.0,
      altitude: 1.0,
      altitudeAccuracy: 1.0,
      heading: 1.0,
      headingAccuracy: 1.0,
      speed: 1.0,
      speedAccuracy: 1.0,
    );
  }

  // عمل override لباقي الدوال الإجبارية لمنع الأخطاء أثناء التيست
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('LocationService Unit Tests (TDD Approach)', () {
    late LocationService locationService;

    setUp(() {
      locationService = LocationService();
      // هنا بنجبر الـ Geolocator يشتغل بالـ Mock اللي عملناه بدل ما يروح للموبايل الحقيقي
      GeolocatorPlatform.instance = MockGeolocatorPlatform();
    });

    test('getCurrentLocation should return valid coordinates when GPS and permissions are OK', () async {
      // Act: استدعاء الدالة اللي بنختبرها
      final position = await locationService.getCurrentLocation();

      // Assert: التأكد إن الإحداثيات الراجعة هي بالظبط اللي حطيناها في الـ Mock
      expect(position.latitude, 30.0444);
      expect(position.longitude, 31.2357);
    });
  });
}