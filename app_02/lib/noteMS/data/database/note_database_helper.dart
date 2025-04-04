import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/note.dart';

class NoteDatabaseHelper {
  static final NoteDatabaseHelper instance = NoteDatabaseHelper._init();
  static Database? _database;

  NoteDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 3, // Tăng version từ 2 lên 3
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      content TEXT NOT NULL,
      priority INTEGER NOT NULL,
      createdAt TEXT NOT NULL,
      modifiedAt TEXT NOT NULL,
      tags TEXT,
      color TEXT,
      isCompleted INTEGER NOT NULL DEFAULT 0,
      imagePath TEXT -- Thêm cột imagePath
    )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE notes ADD COLUMN isCompleted INTEGER NOT NULL DEFAULT 0');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE notes ADD COLUMN imagePath TEXT');
    }
  }

  Future<Note> insertNote(Note note) async {
    final db = await database;
    final id = await db.insert('notes', note.toMap());
    return note.copyWith(id: id);
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final result = await db.query('notes', orderBy: 'modifiedAt DESC');
    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<Note?> getNoteById(int id) async {
    final db = await database;
    final result = await db.query('notes', where: 'id = ?', whereArgs: [id], limit: 1);
    return result.isNotEmpty ? Note.fromMap(result.first) : null;
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Note>> getNotesByPriority(int priority) async {
    final db = await database;
    final result = await db.query(
      'notes',
      where: 'priority = ?',
      whereArgs: [priority],
      orderBy: 'modifiedAt DESC',
    );
    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<List<Note>> searchNotes(String query) async {
    final db = await database;
    final result = await db.query(
      'notes',
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'modifiedAt DESC',
    );
    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future close() async {
    final db = await database;
    _database = null;
    await db.close();
  }
}