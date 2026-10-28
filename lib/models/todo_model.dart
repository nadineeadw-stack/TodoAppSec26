class TodoModel {
  final String id;
  final String title;
  final String description;
  final bool isDone;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {'title': title, 'description': description, 'isDone': isDone};
  }

  factory TodoModel.fromMap(Map<String, dynamic> map, String documentId) {
    return TodoModel(
      id: documentId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isDone: map['isDone'] ?? false,
    );
  }
}
