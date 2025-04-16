import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/note.dart';
import '../data/folder.dart';

class NoteApiService {
  static const String baseUrl = 'https://notes-api-zrfp.onrender.com';

  Future<http.Response> _makeRequest({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
      final headers = {'Content-Type': 'application/json'};
      http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: headers).timeout(const Duration(seconds: 10));
          break;
        case 'POST':
          response = await http.post(uri, headers: headers, body: jsonEncode(body)).timeout(const Duration(seconds: 10));
          break;
        case 'PUT':
          response = await http.put(uri, headers: headers, body: jsonEncode(body)).timeout(const Duration(seconds: 10));
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers).timeout(const Duration(seconds: 10));
          break;
        default:
          throw Exception('Phương thức HTTP không được hỗ trợ: $method');
      }

      return response;
    } catch (e) {
      throw Exception('Lỗi khi gọi API: ${e.toString()}');
    }
  }

  Future<void> _ensureDefaultFolders() async {
    final folders = await getAllFolders();
    bool hasDefaultFolder = folders.any((folder) => folder.name == 'Thư mục Ghi chú');
    bool hasUnassignedFolder = folders.any((folder) => folder.name == 'Chưa phân loại');

    if (!hasDefaultFolder) {
      final defaultFolder = Folder(name: 'Thư mục Ghi chú', noteIds: []);
      await insertFolder(defaultFolder);
    }
    if (!hasUnassignedFolder) {
      final unassignedFolder = Folder(name: 'Chưa phân loại', noteIds: []);
      await insertFolder(unassignedFolder);
    }
  }

  Future<String> ensureDefaultFolder() async {
    try {
      await _ensureDefaultFolders();
      final folders = await getAllFolders();
      final defaultFolder = folders.firstWhere(
            (folder) => folder.name == 'Thư mục Ghi chú',
        orElse: () => throw Exception('Không tìm thấy thư mục mặc định'),
      );
      if (defaultFolder.id == null) {
        throw Exception('ID của thư mục mặc định không hợp lệ');
      }
      return defaultFolder.id!;
    } catch (e) {
      throw Exception('Lỗi khi đảm bảo thư mục mặc định: $e');
    }
  }

  Future<String> getUnassignedFolderId() async {
    try {
      await _ensureDefaultFolders();
      final folders = await getAllFolders();
      final unassignedFolder = folders.firstWhere(
            (folder) => folder.name == 'Chưa phân loại',
        orElse: () => throw Exception('Không tìm thấy thư mục Chưa phân loại'),
      );
      if (unassignedFolder.id == null) {
        throw Exception('ID của thư mục Chưa phân loại không hợp lệ');
      }
      return unassignedFolder.id!;
    } catch (e) {
      throw Exception('Lỗi khi lấy thư mục Chưa phân loại: $e');
    }
  }

  Future<Note> insertNote(Note note) async {
    if (note.title.isEmpty || note.content.isEmpty) {
      throw Exception('Tiêu đề và nội dung không được để trống');
    }

    final response = await _makeRequest(
      endpoint: '/notes',
      method: 'POST',
      body: note.toMap(),
    );

    if (response.statusCode == 201) {
      return Note.fromMap(jsonDecode(response.body));
    }
    throw Exception('Lỗi khi thêm ghi chú: Mã trạng thái ${response.statusCode}');
  }

  Future<List<Note>> getAllNotes() async {
    final response = await _makeRequest(endpoint: '/notes', method: 'GET');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Note.fromMap(json)).toList();
    }
    throw Exception('Lỗi khi tải ghi chú: Mã trạng thái ${response.statusCode}');
  }

  Future<Note?> getNoteById(String id) async {
    if (id.isEmpty) {
      throw Exception('ID ghi chú không hợp lệ');
    }

    final response = await _makeRequest(endpoint: '/notes/$id', method: 'GET');

    if (response.statusCode == 200) {
      return Note.fromMap(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    }
    throw Exception('Lỗi khi tải ghi chú: Mã trạng thái ${response.statusCode}');
  }

  Future<void> updateNote(Note note) async {
    if (note.id == null || note.title.isEmpty) {
      throw Exception('Thông tin ghi chú không hợp lệ');
    }

    final response = await _makeRequest(
      endpoint: '/notes/${note.id}',
      method: 'PUT',
      body: note.toMap(),
    );

    if (response.statusCode != 200) {
      throw Exception('Lỗi khi cập nhật ghi chú: Mã trạng thái ${response.statusCode}');
    }
  }

  Future<void> deleteNote(String id) async {
    if (id.isEmpty) {
      throw Exception('ID ghi chú không hợp lệ');
    }

    // Kiểm tra xem ghi chú có tồn tại không
    final note = await getNoteById(id);
    if (note == null) {
      return; // Không cần xóa nếu ghi chú không tồn tại
    }

    final response = await _makeRequest(endpoint: '/notes/$id', method: 'DELETE');

    if (response.statusCode != 200) {
      throw Exception('Lỗi khi xóa ghi chú: Mã trạng thái ${response.statusCode}');
    }
  }

  Future<List<Note>> getNotesByPriority(int priority) async {
    if (priority < 1) {
      throw Exception('Mức ưu tiên không hợp lệ');
    }

    final response = await _makeRequest(
      endpoint: '/notes',
      method: 'GET',
      queryParams: {'priority': priority.toString()},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Note.fromMap(json)).toList();
    }
    throw Exception('Lỗi khi tải ghi chú theo ưu tiên: Mã trạng thái ${response.statusCode}');
  }

  Future<List<Note>> searchNotes(String query) async {
    if (query.isEmpty) {
      return getAllNotes();
    }

    final response = await _makeRequest(
      endpoint: '/notes',
      method: 'GET',
      queryParams: {'title_like': query},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Note.fromMap(json)).toList();
    }
    throw Exception('Lỗi khi tìm kiếm ghi chú: Mã trạng thái ${response.statusCode}');
  }

  Future<List<Folder>> getAllFolders() async {
    final response = await _makeRequest(endpoint: '/folders', method: 'GET');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Folder.fromMap(json)).toList();
    }
    throw Exception('Lỗi khi tải danh sách thư mục: Mã trạng thái ${response.statusCode}');
  }

  Future<Folder> insertFolder(Folder folder) async {
    if (folder.name.isEmpty) {
      throw Exception('Tên thư mục không được để trống');
    }

    final response = await _makeRequest(
      endpoint: '/folders',
      method: 'POST',
      body: folder.toMap(),
    );

    if (response.statusCode == 201) {
      return Folder.fromMap(jsonDecode(response.body));
    }
    throw Exception('Lỗi khi thêm thư mục: Mã trạng thái ${response.statusCode}');
  }

  Future<void> updateFolder(Folder folder) async {
    if (folder.id == null || folder.name.isEmpty) {
      throw Exception('Thông tin thư mục không hợp lệ');
    }

    // Kiểm tra xem thư mục có phải là thư mục mặc định không
    final folders = await getAllFolders();
    final existingFolder = folders.firstWhere((f) => f.id == folder.id);
    if (existingFolder.name == 'Thư mục Ghi chú' || existingFolder.name == 'Chưa phân loại') {
      throw Exception('Không thể đổi tên thư mục mặc định');
    }

    final response = await _makeRequest(
      endpoint: '/folders/${folder.id}',
      method: 'PUT',
      body: folder.toMap(),
    );

    if (response.statusCode != 200) {
      throw Exception('Lỗi khi cập nhật thư mục: Mã trạng thái ${response.statusCode}');
    }
  }

  Future<void> deleteFolder(String id) async {
    if (id.isEmpty) {
      throw Exception('ID thư mục không hợp lệ');
    }

    // Kiểm tra xem thư mục có phải là thư mục mặc định không
    final folders = await getAllFolders();
    final folder = folders.firstWhere((f) => f.id == id);
    if (folder.name == 'Thư mục Ghi chú' || folder.name == 'Chưa phân loại') {
      throw Exception('Không thể xóa thư mục mặc định');
    }

    // Lấy ID của thư mục "Chưa phân loại"
    final unassignedFolderId = await getUnassignedFolderId();

    // Chuyển tất cả ghi chú trong thư mục sang "Chưa phân loại"
    for (var noteId in folder.noteIds) {
      try {
        // Kiểm tra xem noteId có tồn tại trong notes không
        final note = await getNoteById(noteId);
        if (note == null) {
          continue; // Bỏ qua nếu ghi chú không tồn tại
        }
        // Kiểm tra xem folderId của note có khớp với thư mục đang xóa không
        if (note.folderId == id) {
          await removeNoteFromFolder(noteId, id);
          await addNoteToFolder(noteId, unassignedFolderId);
          // Tạo bản sao của note với folderId mới
          final updatedNote = Note(
            id: note.id,
            title: note.title,
            content: note.content,
            priority: note.priority,
            createdAt: note.createdAt,
            modifiedAt: note.modifiedAt,
            color: note.color,
            isCompleted: note.isCompleted,
            imagePaths: note.imagePaths,
            folderId: unassignedFolderId, // Cập nhật folderId mới
          );
          await updateNote(updatedNote);
        }
      } catch (e) {
        throw Exception('Lỗi khi chuyển ghi chú sang thư mục "Chưa phân loại": $e');
      }
    }

    // Xóa thư mục
    final response = await _makeRequest(endpoint: '/folders/$id', method: 'DELETE');
    if (response.statusCode != 200) {
      throw Exception('Lỗi khi xóa thư mục: Mã trạng thái ${response.statusCode}');
    }
  }

  Future<Folder?> getFolderById(String id) async {
    if (id.isEmpty) {
      throw Exception('ID thư mục không hợp lệ');
    }

    final response = await _makeRequest(endpoint: '/folders/$id', method: 'GET');

    if (response.statusCode == 200) {
      return Folder.fromMap(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    }
    throw Exception('Lỗi khi tải thư mục: Mã trạng thái ${response.statusCode}');
  }

  Future<void> addNoteToFolder(String noteId, String folderId) async {
    if (noteId.isEmpty || folderId.isEmpty) {
      throw Exception('ID ghi chú hoặc thư mục không hợp lệ');
    }

    // Kiểm tra xem ghi chú và thư mục có tồn tại không
    final note = await getNoteById(noteId);
    final folder = await getFolderById(folderId);
    if (note == null || folder == null) {
      throw Exception('Ghi chú hoặc thư mục không tồn tại');
    }

    final response = await _makeRequest(
      endpoint: '/folders/$folderId/notes',
      method: 'POST',
      body: {'noteId': noteId},
    );

    if (response.statusCode != 201) {
      throw Exception('Lỗi khi thêm ghi chú vào thư mục: Mã trạng thái ${response.statusCode}');
    }
  }

  Future<void> removeNoteFromFolder(String noteId, String folderId) async {
    if (noteId.isEmpty || folderId.isEmpty) {
      throw Exception('ID ghi chú hoặc thư mục không hợp lệ');
    }

    // Kiểm tra xem noteId có trong folder không
    final folder = await getFolderById(folderId);
    if (folder == null || !folder.noteIds.contains(noteId)) {
      return; // Không cần xóa nếu noteId không tồn tại trong folder
    }

    final response = await _makeRequest(
      endpoint: '/folders/$folderId/notes/$noteId',
      method: 'DELETE',
    );

    if (response.statusCode != 200) {
      throw Exception('Lỗi khi xóa ghi chú khỏi thư mục: Mã trạng thái ${response.statusCode}');
    }
  }
}