class Task {
  int? id;
  String title;
  bool isCompleted;

  Task({this.id, required this.title, this.isCompleted = false});

  // Convert a Task to Map for storing in the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  // Create a Task from Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
