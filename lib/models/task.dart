enum TaskPriority { tinggi, sedang, rendah}

extension TaskPriorityLabel on TaskPriority {
  String get label {
    switch (this) {
      case TaskPriority.tinggi:
        return 'Prioritas Tinggi';
      case TaskPriority.sedang:
        return 'Prioritas Sedang';
      case TaskPriority.rendah:
        return 'Prioritas Rendah';
    }
  }
}

class TodoTask{
  final String id;
  String title;
  String projectName;
  TaskPriority priority;
  DateTime date;
  String time;
  bool isDone;

  TodoTask({
    required this.id,
    required this.title,
    required this.projectName,
    required this.priority,
    required this.date,
    required this.time,
    this.isDone = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'projectName': projectName,
    'priority': priority.name,
    'date': date.toIso8601String(),
    'time': time,
    'isDone': isDone,
  };
  factory TodoTask.fromJson(Map<String, dynamic> json) => TodoTask(
    id: json['id'] as String,
    title: json['title'] as String,
    projectName: json['projectName'] as String,
    priority: TaskPriority.values.firstWhere(
      (p) => p.name == json['priority'],
      orElse: () => TaskPriority.sedang,
    ),
    date: DateTime.parse(json['date'] as String),
    time: json['time'] as String,
    isDone: json['isDone']as bool? ?? false,
  );
}