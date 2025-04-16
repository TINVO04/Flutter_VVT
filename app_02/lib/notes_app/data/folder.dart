class Folder {
  final String? id;
  final String name;
  final List<String> noteIds;

  Folder({
    this.id,
    required this.name,
    required this.noteIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'noteIds': noteIds,
    };
  }

  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: map['id']?.toString(),
      name: map['name'] as String? ?? 'Untitled Folder',
      noteIds: map['noteIds'] != null
          ? List<String>.from(map['noteIds'] as List)
          : [],
    );
  }
}