import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/model/note.dart';
import '../../data/repositories/note_repository.dart';

class NoteProvider with ChangeNotifier {
  final NoteRepository repository;
  List<Note> _notes = [];
  bool _isGridView = false;
  bool _isLoading = false;

  NoteProvider(this.repository) {
    fetchNotes();
  }

  List<Note> get notes => _notes;
  bool get isGridView => _isGridView;
  bool get isLoading => _isLoading;

  Future<void> fetchNotes() async {
    _isLoading = true;
    notifyListeners();
    try {
      _notes = await repository.getAllNotes();
    } catch (e) {
      print('Lỗi khi lấy ghi chú: $e');
      _notes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchNotes(String query) async {
    _isLoading = true;
    notifyListeners();
    try {
      _notes = await repository.searchNotes(query);
    } catch (e) {
      print('Lỗi khi tìm kiếm: $e');
      _notes = [];


    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> filterByPriority(int priority) async {
    _isLoading = true;
    notifyListeners();
    try {
      _notes = await repository.getNotesByPriority(priority);
    } catch (e) {
      print('Lỗi khi lọc: $e');
      _notes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleView() {
    _isGridView = !_isGridView;
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    try {
      final newNote = await repository.insertNote(note);
      _notes.add(newNote);
      notifyListeners();
    } catch (e) {
      print('Lỗi khi thêm ghi chú: $e');
      throw e;
    }
  }

  Future<void> updateNote(Note note) async {
    if (note.id == null) {
      print('Lỗi: ID của ghi chú là null, không thể cập nhật');
      return;
    }
    try {
      await repository.updateNote(note);
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes[index] = note;
      }
      notifyListeners();
    } catch (e) {
      print('Lỗi khi cập nhật ghi chú: $e');
      // Nếu có lỗi (ví dụ: 404), đồng bộ lại danh sách từ server
      await fetchNotes();
      throw e;
    }
  }

  Future<void> deleteNote(int? id) async {
    if (id == null) {
      print('Lỗi: ID của ghi chú là null, không thể xóa');
      return;
    }
    try {
      final note = _notes.firstWhere((note) => note.id == id, orElse: () => throw Exception('Không tìm thấy ghi chú với ID: $id'));
      if (note.imagePath != null) {
        await File(note.imagePath!).delete();
      }
      await repository.deleteNote(id);
      _notes.removeWhere((note) => note.id == id);
      notifyListeners();
    } catch (e) {
      print('Lỗi khi xóa ghi chú: $e');
      // Nếu có lỗi, đồng bộ lại danh sách từ server
      await fetchNotes();
      throw e;
    }
  }

  Future<void> toggleCompleted(int? id, bool isCompleted) async {
    if (id == null) {
      print('Lỗi: ID của ghi chú là null, không thể cập nhật trạng thái');
      return;
    }
    try {
      final note = _notes.firstWhere((note) => note.id == id, orElse: () => throw Exception('Không tìm thấy ghi chú với ID: $id'));
      final updatedNote = note.copyWith(
        isCompleted: isCompleted,
        modifiedAt: DateTime.now(),
      );
      await repository.updateNote(updatedNote);
      final index = _notes.indexWhere((note) => note.id == id);
      if (index != -1) {
        _notes[index] = updatedNote;
      }
      notifyListeners();
    } catch (e) {
      print('Lỗi khi cập nhật trạng thái hoàn thành: $e');
      // Nếu có lỗi, đồng bộ lại danh sách từ server
      await fetchNotes();
      throw e;
    }
  }
}