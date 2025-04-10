import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/note.dart';

abstract class NoteRepository {
  Future<Note> insertNote(Note note);
  Future<List<Note>> getAllNotes();
  Future<Note?> getNoteById(int id);
  Future<int> updateNote(Note note);
  Future<int> deleteNote(int id);
  Future<List<Note>> getNotesByPriority(int priority);
  Future<List<Note>> searchNotes(String query);
}

class NoteRepositoryImpl implements NoteRepository {
  // static const String baseUrl = 'http://192.168.100.165:3000';
  static const String baseUrl = 'https://my-json-server.typicode.com/TINVO04/flutter_notes';

  @override
  Future<Note> insertNote(Note note) async {
    try {
      // Lấy danh sách hiện tại để tạo id mới
      final allNotes = await getAllNotes();
      int newId = 1;
      if (allNotes.isNotEmpty) {
        final maxId = allNotes.map((n) => n.id ?? 0).reduce((a, b) => a > b ? a : b);
        newId = maxId + 1;
      }

      // Thêm id vào note trước khi gửi
      final noteWithId = note.copyWith(id: newId);

      final response = await http.post(
        Uri.parse('$baseUrl/notes'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(noteWithId.toMap()),
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final newNote = Note.fromMap(data);
        if (newNote.id == null) {
          throw Exception('json-server không tạo ID cho ghi chú mới');
        }
        return newNote;
      } else {
        throw Exception('Lỗi khi thêm ghi chú: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi thêm ghi chú: $e');
    }
  }

  @override
  Future<List<Note>> getAllNotes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/notes'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Note.fromMap(json)).toList();
      } else {
        throw Exception('Lỗi khi lấy danh sách ghi chú: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách ghi chú: $e');
    }
  }

  @override
  Future<Note?> getNoteById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/notes/$id'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Note.fromMap(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Lỗi khi lấy ghi chú theo ID: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy ghi chú theo ID: $e');
    }
  }

  @override
  Future<int> updateNote(Note note) async {
    try {
      // Kiểm tra xem ghi chú có tồn tại không trước khi cập nhật
      final existingNote = await getNoteById(note.id!);
      if (existingNote == null) {
        throw Exception('Không tìm thấy ghi chú với ID: ${note.id}');
      }

      final response = await http.put(
        Uri.parse('$baseUrl/notes/${note.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(note.toMap()),
      );
      if (response.statusCode == 200) {
        return 1;
      } else {
        throw Exception('Lỗi khi cập nhật ghi chú: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi cập nhật ghi chú: $e');
    }
  }

  @override
  Future<int> deleteNote(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/notes/$id'));
      if (response.statusCode == 200) {
        return 1;
      } else {
        throw Exception('Lỗi khi xóa ghi chú: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi xóa ghi chú: $e');
    }
  }

  @override
  Future<List<Note>> getNotesByPriority(int priority) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/notes?priority=$priority'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Note.fromMap(json)).toList();
      } else {
        throw Exception('Lỗi khi lấy ghi chú theo ưu tiên: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy ghi chú theo ưu tiên: $e');
    }
  }

  @override
  Future<List<Note>> searchNotes(String query) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/notes?title_like=$query'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Note.fromMap(json)).toList();
      } else {
        throw Exception('Lỗi khi tìm kiếm ghi chú: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi tìm kiếm ghi chú: $e');
    }
  }
}