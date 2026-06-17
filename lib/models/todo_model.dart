class TodoItemModel {
  final String id;
  final String title;
  bool isCompleted;
  
  TodoItemModel({
 required this.id,
 required this.title,
 this.isCompleted=false
  });
}