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

  Future<void> deleteNote(int id) async {
    try {
      final note = _notes.firstWhere((note) => note.id == id);
      if (note.imagePath != null) {
        await File(note.imagePath!).delete();
      }
      await repository.deleteNote(id);
      await fetchNotes();
    } catch (e) {
      print('Lỗi khi xóa ghi chú: $e');
    }
  }

  Future<void> toggleCompleted(int id, bool isCompleted) async {
    try {
      final note = _notes.firstWhere((note) => note.id == id);
      final updatedNote = note.copyWith(
        isCompleted: isCompleted,
        modifiedAt: DateTime.now(),
      );
      await repository.updateNote(updatedNote);
      await fetchNotes();
    } catch (e) {
      print('Lỗi khi cập nhật trạng thái hoàn thành: $e');
    }
  }
}