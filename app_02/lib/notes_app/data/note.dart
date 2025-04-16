class Note {
  final String? id;
  final String title;
  final String content;
  final int priority;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final String? color;
  final bool isCompleted;
  final List<String>? imagePaths;
  final String? folderId; // Thêm trường folderId

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.createdAt,
    required this.modifiedAt,
    this.color,
    required this.isCompleted,
    this.imagePaths,
    this.folderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
      'color': color,
      'isCompleted': isCompleted,
      'imagePaths': imagePaths,
      'folderId': folderId, // Thêm folderId vào map
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id']?.toString(),
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      priority: map['priority'] as int? ?? 1,
      createdAt: DateTime.parse(map['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      modifiedAt: DateTime.parse(map['modifiedAt'] as String? ?? DateTime.now().toIso8601String()),
      color: map['color']?.toString(),
      isCompleted: map['isCompleted'] as bool? ?? false,
      imagePaths: map['imagePaths'] != null ? List<String>.from(map['imagePaths'] as List) : null,
      folderId: map['folderId']?.toString(), // Parse folderId
    );
  }
}