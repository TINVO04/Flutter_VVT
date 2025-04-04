class Note {
  final int? id;
  final String title;
  final String content;
  final int priority;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final List<String>? tags;
  final String? color;
  final bool isCompleted;
  final String? imagePath; // Thêm imagePath

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.createdAt,
    required this.modifiedAt,
    this.tags,
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
      'tags': tags?.join(','),
      'color': color,
      'isCompleted': isCompleted ? 1 : 0,
      'imagePath': imagePath, // Thêm imagePath vào map
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      priority: map['priority'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      modifiedAt: DateTime.parse(map['modifiedAt'] as String),
      tags: map['tags'] != null ? (map['tags'] as String).split(',') : null,
      color: map['color'] as String?,
      isCompleted: map['isCompleted'] == 1,
      imagePath: map['imagePath'] as String?, // Lấy imagePath từ map
    );
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    int? priority,
    DateTime? createdAt,
    DateTime? modifiedAt,
    List<String>? tags,
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
      tags: tags ?? this.tags,
      color: color ?? this.color,
      isCompleted: isCompleted ?? this.isCompleted,
      imagePath: imagePath ?? this.imagePath, // Thêm imagePath vào copyWith
    );
  }

  @override
  String toString() {
    return 'Note(id: $id, title: $title, content: $content, priority: $priority, createdAt: $createdAt, modifiedAt: $modifiedAt, tags: $tags, color: $color, isCompleted: $isCompleted, imagePath: $imagePath)';
  }
}