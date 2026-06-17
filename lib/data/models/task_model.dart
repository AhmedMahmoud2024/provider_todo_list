class TaskModel {
  final String id;
  final String title;
  bool isDone;
  
  TaskModel({
 required this.id,
 required this.title,
 this.isDone=false
  });
  
 TaskModel copyWith({
  String?id,
  String ? title,
  bool? isDone
 }){
 return TaskModel(
  id: id ?? this.id,
   title: title ?? this.title,
   isDone: isDone?? this.isDone
   );
  }
}