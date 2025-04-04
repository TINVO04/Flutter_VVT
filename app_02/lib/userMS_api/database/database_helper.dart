import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// Class quản lý SQLite database
class DatabaseHelper {
  // Singleton pattern đảm bảo chỉ có một instance duy nhất
  static final DatabaseHelper instance = DatabaseHelper._init();

  // Biến lưu trữ database
  static Database? _database;

  // Constructor private để ngăn tạo instance từ bên ngoài
  DatabaseHelper._init();

  // Getter lấy database, nếu chưa có thì tạo mới
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  // Khởi tạo database với tên file
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Tạo bảng users khi database được tạo lần đầu
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        birthDate TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        city TEXT NOT NULL,
        gender TEXT NOT NULL,
        password TEXT NOT NULL,
        profileImagePath TEXT
      )
    ''');
  }

  // Create - Thêm user mới
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await instance.database;
    return await db.insert('users', user);
  }

  // Read - Đọc tất cả users
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await instance.database;
    return await db.query('users');
  }

  // Read - Đọc user theo id
  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  // Update - Cập nhật user
  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await instance.database;
    return await db.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete - Xóa user
  Future<int> deleteUser(int id) async {
    final db = await instance.database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Đóng database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}