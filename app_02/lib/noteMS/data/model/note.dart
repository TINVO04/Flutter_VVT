class Note {
  final int? id;
  final String title;
  final String content;
  final int priority;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final String? color;
  final bool isCompleted;
  final String? imagePath;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.createdAt,
    required this.modifiedAt,
    this.color,
    this.isCompleted = false,
    this.imagePath,
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
      'isCompleted': isCompleted ? 1 : 0,
      'imagePath': imagePath,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] is String ? int.tryParse(map['id'] as String) : map['id'] as int?, // Xử lý id là String hoặc int
      title: map['title'] as String,
      content: map['content'] as String,
      priority: map['priority'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      modifiedAt: DateTime.parse(map['modifiedAt'] as String),
      color: map['color'] as String?,
      isCompleted: map['isCompleted'] == 1 || map['isCompleted'] == true,
      imagePath: map['imagePath'] as String?,
    );
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    int? priority,
    DateTime? createdAt,
    DateTime? modifiedAt,
    String? color,
    bool? isCompleted,
    String? imagePath,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      color: color ?? this.color,
      isCompleted: isCompleted ?? this.isCompleted,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  String toString() {
    return 'Note(id: $id, title: $title, content: $content, priority: $priority, createdAt: $createdAt, modifiedAt: $modifiedAt, color: $color, isCompleted: $isCompleted, imagePath: $imagePath)';
  }
}