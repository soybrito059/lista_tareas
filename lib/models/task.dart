class Task {
  final String title;
  final String description;
  final DateTime dateTime;
  final String category;
  bool isCompleted;
  List<String> attachments;

  Task({
    required this.title,
    required this.description,
    required this.dateTime,
    required this.category,
    this.isCompleted = false,
    this.attachments = const [],
  });
}
