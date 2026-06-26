class UpdatedTaskModel {
  final String id;
  final String title;
  final String description;
  final double? latitude;
  final double? longitude;
  final String? locationName;
  bool isDone;
  
  UpdatedTaskModel({
 required this.id,
 required this.title,
  required this.description,
 this.isDone=false,
 this.latitude,
 this.longitude,
 this.locationName
  });
  
 UpdatedTaskModel copyWith({
  String?id,
  String ? title,
  String? description,
  bool? isDone,
  double? latitude,
  double? longitude,
  String? locationName
 }){
 return UpdatedTaskModel(
  id: id ?? this.id,
   title: title ?? this.title,
   description:description ?? this.description,
   isDone: isDone?? this.isDone,
   latitude: latitude ?? this.latitude,
   longitude: longitude ?? this.longitude,
   locationName: locationName ?? this.locationName

   );
  }

   // 📥 تحويل من JSON (عند القراءة من SharedPreferences)
  factory UpdatedTaskModel.fromJson(Map<String, dynamic> json) {
    return UpdatedTaskModel(
      id: json['id'] ?? "",
      title: json['title']?? "",
      description: json['description'] ?? "",
      isDone: json['isDone'] as bool? ?? false,
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      locationName: json['locationName'] ??'',
    );
  }

  // 📤 تحويل إلى JSON (عند الحفظ في SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
      'latitude': latitude,
      'longitude': longitude,
      'locationName': locationName,
    };
  }
}
