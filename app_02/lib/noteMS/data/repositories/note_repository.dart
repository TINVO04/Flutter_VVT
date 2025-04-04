import '../database/note_database_helper.dart';
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
  final NoteDatabaseHelper _dbHelper;

  NoteRepositoryImpl(this._dbHelper);

  @override
  Future<Note> insertNote(Note note) async {
    try {
      return await _dbHelper.insertNote(note);
    } catch (e) {
      throw Exception('Lỗi khi thêm ghi chú: $e');
    }
  }

  @override
  Future<List<Note>> getAllNotes() async {
    try {
      return await _dbHelper.getAllNotes();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách ghi chú: $e');
    }
  }

  @override
  Future<Note?> getNoteById(int id) async {
    try {
      return await _dbHelper.getNoteById(id);
    } catch (e) {
      throw Exception('Lỗi khi lấy ghi chú theo ID: $e');
    }
  }

  @override
  Future<int> updateNote(Note note) async {
    try {
      return await _dbHelper.updateNote(note);
    } catch (e) {
      throw Exception('Lỗi khi cập nhật ghi chú: $e');
    }
  }

  @override
  Future<int> deleteNote(int id) async {
    try {
      return await _dbHelper.deleteNote(id);
    } catch (e) {
      throw Exception('Lỗi khi xóa ghi chú: $e');
    }
  }

  @override
  Future<List<Note>> getNotesByPriority(int priority) async {
    try {
      return await _dbHelper.getNotesByPriority(priority);
    } catch (e) {
      throw Exception('Lỗi khi lấy ghi chú theo ưu tiên: $e');
    }
  }

  @override
  Future<List<Note>> searchNotes(String query) async {
    try {
      return await _dbHelper.searchNotes(query);
    } catch (e) {
      throw Exception('Lỗi khi tìm kiếm ghi chú: $e');
    }
  }
}