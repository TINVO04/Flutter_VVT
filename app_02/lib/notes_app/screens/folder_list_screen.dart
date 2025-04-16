import 'package:flutter/material.dart';
import '../api/note_api_service.dart';
import '../data/folder.dart';

class FolderListScreen extends StatefulWidget {
  const FolderListScreen({super.key});

  @override
  State<FolderListScreen> createState() => _FolderListScreenState();
}

class _FolderListScreenState extends State<FolderListScreen> {
  final NoteApiService _apiService = NoteApiService();
  List<Folder> _folders = [];
  List<Folder> _filteredFolders = [];
  bool _isLoading = false;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchFolders();
    _searchController.addListener(_filterFolders);
  }

  Future<void> _fetchFolders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final folders = await _apiService.getAllFolders();
      setState(() {
        _folders = folders;
        _filteredFolders = folders;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi tải danh sách thư mục: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterFolders() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredFolders = _folders;
      } else {
        _filteredFolders = _folders
            .where((folder) => folder.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  Future<void> _addFolder() async {
    final folderNameController = TextEditingController();
    final folderName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạo thư mục mới'),
        content: TextField(
          controller: folderNameController,
          decoration: const InputDecoration(hintText: 'Nhập tên thư mục'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, folderNameController.text),
            child: const Text('Tạo'),
          ),
        ],
      ),
    );

    if (folderName != null && folderName.trim().isNotEmpty) {
      try {
        final newFolder = Folder(name: folderName.trim(), noteIds: []);
        await _apiService.insertFolder(newFolder);
        await _fetchFolders();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tạo thư mục "$folderName" thành công')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tạo thư mục: $e')),
        );
      }
    }
  }

  Future<void> _editFolder(Folder folder) async {
    // Ngăn đổi tên thư mục mặc định
    if (folder.name == 'Thư mục Ghi chú' || folder.name == 'Chưa phân loại') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể đổi tên thư mục mặc định')),
      );
      return;
    }

    final folderNameController = TextEditingController(text: folder.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sửa tên thư mục'),
        content: TextField(
          controller: folderNameController,
          decoration: const InputDecoration(hintText: 'Nhập tên mới'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, folderNameController.text),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );

    if (newName != null && newName.trim().isNotEmpty && newName != folder.name) {
      try {
        final updatedFolder = Folder(
          id: folder.id,
          name: newName.trim(),
          noteIds: folder.noteIds,
        );
        await _apiService.updateFolder(updatedFolder);
        await _fetchFolders();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã cập nhật tên thư mục thành "$newName"')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi sửa thư mục: $e')),
        );
      }
    }
  }

  Future<void> _deleteFolder(Folder folder) async {
    // Ngăn xóa thư mục mặc định
    if (folder.name == 'Thư mục Ghi chú' || folder.name == 'Chưa phân loại') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể xóa thư mục mặc định')),
      );
      return;
    }

    if (folder.noteIds.isNotEmpty) {
      final confirmDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Xác nhận xóa thư mục'),
          content: Text(
              'Thư mục "${folder.name}" chứa ${folder.noteIds.length} ghi chú. Bạn có chắc chắn muốn xóa? Ghi chú sẽ được chuyển về thư mục "Chưa phân loại".'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Xóa'),
            ),
          ],
        ),
      );

      if (confirmDelete != true) return;
    }

    try {
      await _apiService.deleteFolder(folder.id!);
      await _fetchFolders();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xóa thư mục "${folder.name}"')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi xóa thư mục: $e')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý thư mục'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm thư mục',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? Center(
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
                  : _filteredFolders.isEmpty
                  ? const Center(
                child: Text('Không có thư mục nào'),
              )
                  : ListView.builder(
                itemCount: _filteredFolders.length,
                itemBuilder: (context, index) {
                  final folder = _filteredFolders[index];
                  return ListTile(
                    leading: const Icon(Icons.folder),
                    title: Text(folder.name),
                    subtitle: Text('${folder.noteIds.length} ghi chú'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editFolder(folder),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteFolder(folder),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFolder,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}