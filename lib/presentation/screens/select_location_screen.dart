import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider_todo_list/data/services/location_service.dart';// تأكد من المسار عندك

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final LocationService _locationService = LocationService();
  final MapController _mapController = MapController();
  
  LatLng? _selectedPoint; // النقطة التي سيختارها المستخدم
  bool _isLoading = true;  // لحين جلب موقع المستخدم الحالي

  @override
  void initState() {
    super.initState();
    _goToUserCurrentLocation();
  }

  // دالة لجلب موقع المستخدم الحالي وتحريك الخريطة عليه كبداية
  Future<void> _goToUserCurrentLocation() async {
    try {
      Position position = await _locationService.getCurrentLocation();
      setState(() {
        _selectedPoint = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
      // تحريك الكاميرا للموقع الحالي
      _mapController.move(_selectedPoint!, 15.0);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حدد مكان المهمة'),
        actions: [
          if (_selectedPoint != null)
            IconButton(
              icon: const Icon(Icons.check, size: 28, color: Colors.green),
              onPressed: () {
                // نرجع بالنقطة المختارة للشاشة السابقة (Add Task Screen)
                Navigator.pop(context, _selectedPoint);
              },
            )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _selectedPoint ?? const LatLng(30.0444, 31.2357), // القاهرة كاشتراط بديل
                initialZoom: 15.0,
                // 🔥 حل المشكلة الثانية: التقاط الضغطة وتحديث مكان الدبوس
                onTap: (tapPosition, point) {
                  setState(() {
                    _selectedPoint = point;
                  });
                },
              ),
              children: [
                // طبقة مربعات صور الخريطة المجانية من OpenStreetMap
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.provider_todo_list',
                ),
                // طبقة الدبوس (Marker)
                if (_selectedPoint != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selectedPoint!,
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 45,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
      // زرار عائم يعيد المستخدم لموقعه الحالي لو تاه في الخريطة
      floatingActionButton: FloatingActionButton(
        onPressed: _goToUserCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}