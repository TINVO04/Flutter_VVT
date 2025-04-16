import 'dart:io';
import 'package:flutter/material.dart';
import '../api/note_api_service.dart';
import '../data/note.dart';
import '../data/folder.dart';

class NoteDetailScreen extends StatefulWidget {
  final String noteId;

  const NoteDetailScreen({super.key, required this.noteId});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final NoteApiService _apiService = NoteApiService();
  Note? _note;
  Folder? _folder;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNote();
  }

  Future<void> _fetchNote() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final note = await _apiService.getNoteById(widget.noteId);
      if (note == null) {
        setState(() {
          _errorMessage = 'Ghi chú không tồn tại';
          _isLoading = false;
        });
        return;
      }

      Folder? folder;
      if (note.folderId != null) {
        folder = await _apiService.getFolderById(note.folderId!);
      }

      setState(() {
        _note = note;
        _folder = folder;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi tải ghi chú: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết ghi chú')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
          : _note == null
          ? const Center(child: Text('Không tìm thấy ghi chú'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _note!.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('Nội dung: ${_note!.content}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Ưu tiên: ${_note!.priority}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Thư mục: ${_folder?.name ?? "Không thư mục"}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Tạo lúc: ${_note!.createdAt.toLocal()}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Sửa lúc: ${_note!.modifiedAt.toLocal()}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text(
                'Hoàn thành: ${_note!.isCompleted ? "Đã Hoàn Thành" : "Chưa Hoàn Thành"}',
                style: TextStyle(
                    fontSize: 16, color: _note!.isCompleted ? Colors.green : Colors.red),
              ),
              if (_note!.imagePaths != null && _note!.imagePaths!.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Hình ảnh:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _note!.imagePaths!.map((path) => _buildImage(path)).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    try {
      final file = File(imagePath);
      if (!file.existsSync()) {
        return const Icon(Icons.broken_image, size: 200, color: Colors.grey);
      }
      return Image.file(
        file,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.broken_image,
          size: 200,
          color: Colors.grey,
        ),
      );
    } catch (e) {
      return const Icon(Icons.broken_image, size: 200, color: Colors.grey);
    }
  }
}