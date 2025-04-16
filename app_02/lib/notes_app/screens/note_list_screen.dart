import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/note_api_service.dart';
import '../data/note.dart';
import '../data/folder.dart';
import '../screens/account_screen.dart';
import '../screens/folder_list_screen.dart';
import '../screens/login_screen.dart';
import '../screens/note_form_screen.dart';
import '../utils/theme_provider.dart';
import '../widgets/note_item.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final NoteApiService _apiService = NoteApiService();
  List<Note> _notes = [];
  List<Folder> _folders = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _username;
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;
  int _selectedFilter = 0;
  bool _isMultiSelectMode = false;
  List<Note> _selectedNotes = [];
  bool _isGridView = false;
  String? _selectedFolderId;
  String? _unassignedFolderId;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.wait([
      _loadUsername(),
      _loadCachedNotes(),
      _loadCachedFolders(),
      _fetchNotes(),
      _fetchFolders(),
    ]);
  }

  Future<void> _loadUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _username = prefs.getString('username') ?? 'User';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi tải thông tin người dùng: $e';
      });
    }
  }

  Future<void> _loadCachedNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedNotes = prefs.getString('cached_notes');
      if (cachedNotes != null) {
        final List<dynamic> noteList = jsonDecode(cachedNotes);
        setState(() {
          _notes = noteList.map((json) => Note.fromMap(json)).toList();
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi tải dữ liệu từ bộ nhớ: $e';
      });
    }
  }

  Future<void> _loadCachedFolders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedFolders = prefs.getString('cached_folders');
      if (cachedFolders != null) {
        final List<dynamic> folderList = jsonDecode(cachedFolders);
        setState(() {
          _folders = folderList.map((json) => Folder.fromMap(json)).toList();
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi tải dữ liệu thư mục: $e';
      });
    }
  }

  Future<void> _fetchNotes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final notes = await _apiService.getAllNotes();
      setState(() {
        _notes = notes;
      });
      await _cacheNotes(notes);
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi tải danh sách ghi chú: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchFolders() async {
    try {
      final folders = await _apiService.getAllFolders();
      final unassignedFolderId = await _apiService.getUnassignedFolderId();
      setState(() {
        _folders = folders;
        _unassignedFolderId = unassignedFolderId;
      });
      await _cacheFolders(folders);
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi tải danh sách thư mục: $e';
      });
    }
  }

  Future<void> _cacheNotes(List<Note> notes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final noteList = notes.map((note) => note.toMap()).toList();
      await prefs.setString('cached_notes', jsonEncode(noteList));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lưu dữ liệu vào bộ nhớ: $e')),
      );
    }
  }

  Future<void> _cacheFolders(List<Folder> folders) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final folderList = folders.map((folder) => folder.toMap()).toList();
      await prefs.setString('cached_folders', jsonEncode(folderList));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lưu dữ liệu thư mục: $e')),
      );
    }
  }

  Future<void> _searchNotes(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final notes = await _apiService.searchNotes(query);
      setState(() {
        _notes = notes;
      });
      await _cacheNotes(notes);
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi tìm kiếm ghi chú: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có muốn đăng xuất không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Có'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi đăng xuất: $e')),
        );
      }
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chức năng TO-DO chưa được triển khai')),
      );
    }
  }

  void _onFilterTapped(int index, String? folderId) {
    setState(() {
      _selectedFilter = index;
      _selectedFolderId = folderId;
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  void _toggleMultiSelect(Note note) {
    setState(() {
      if (_isMultiSelectMode) {
        if (_selectedNotes.contains(note)) {
          _selectedNotes.remove(note);
        } else {
          _selectedNotes.add(note);
        }
        if (_selectedNotes.isEmpty) {
          _isMultiSelectMode = false;
        }
      } else {
        _isMultiSelectMode = true;
        _selectedNotes.add(note);
      }
    });
  }

  void _cancelMultiSelect() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedNotes.clear();
    });
  }

  Future<void> _deleteSelectedNotes() async {
    try {
      for (var note in _selectedNotes) {
        if (note.id == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ID ghi chú không hợp lệ')),
          );
          continue;
        }
        if (note.folderId != null) {
          // Kiểm tra xem folderId có tồn tại trong danh sách thư mục không
          final folderExists = _folders.any((folder) => folder.id == note.folderId);
          if (folderExists) {
            try {
              await _apiService.removeNoteFromFolder(note.id!, note.folderId!);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Lỗi khi xóa ghi chú khỏi thư mục: $e')),
              );
            }
          }
        }
        await _apiService.deleteNote(note.id!);
      }
      await _fetchNotes();
      await _fetchFolders();
      setState(() {
        _isMultiSelectMode = false;
        _selectedNotes.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi xóa ghi chú: $e')),
      );
    }
  }

  Future<void> _moveSelectedNotes() async {
    final folderId = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chuyển tới thư mục'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: const Text('Không thư mục'),
                onTap: () => Navigator.pop(context, null),
              ),
              ..._folders.map((folder) => ListTile(
                title: Text(folder.name),
                onTap: () => Navigator.pop(context, folder.id),
              )),
            ],
          ),
        ),
      ),
    );

    if (folderId != null || folderId == null) {
      try {
        for (var note in _selectedNotes) {
          if (note.folderId != null) {
            final folderExists = _folders.any((folder) => folder.id == note.folderId);
            if (folderExists) {
              await _apiService.removeNoteFromFolder(note.id!, note.folderId!);
            }
          }
          if (folderId != null) {
            await _apiService.addNoteToFolder(note.id!, folderId);
          }
        }
        await _fetchNotes();
        await _fetchFolders();
        setState(() {
          _isMultiSelectMode = false;
          _selectedNotes.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chuyển ghi chú thành công')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi chuyển ghi chú: $e')),
        );
      }
    }
  }

  Future<void> _createFolder() async {
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
        final newFolder = Folder(
          name: folderName.trim(),
          noteIds: [],
        );
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

  Future<void> _deleteFolder(String folderId) async {
    final folder = _folders.firstWhere((f) => f.id == folderId);

    // Ngăn xóa thư mục mặc định
    if (folder.name == 'Thư mục Ghi chú' || folder.name == 'Chưa phân loại') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể xóa thư mục mặc định')),
      );
      return;
    }

    if (folder.noteIds.isNotEmpty) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Xóa thư mục'),
          content: Text(
              'Thư mục "${folder.name}" chứa ${folder.noteIds.length} ghi chú. Bạn có chắc muốn xóa? Ghi chú sẽ được chuyển về thư mục "Chưa phân loại".'),
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

      if (confirm != true) return;
    }

    try {
      await _apiService.deleteFolder(folderId);
      if (_selectedFolderId == folderId) {
        setState(() {
          _selectedFolderId = null;
          _selectedFilter = 0;
        });
      }
      await Future.wait([_fetchNotes(), _fetchFolders()]);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Xóa thư mục thành công')),
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

  List<Note> get _filteredNotes {
    if (_selectedFolderId == null) {
      return _notes; // Tất cả ghi chú
    } else if (_selectedFolderId == _unassignedFolderId) {
      final unassignedFolder = _folders.firstWhere(
            (f) => f.id == _unassignedFolderId,
        orElse: () => Folder(id: null, name: '', noteIds: []),
      );
      return _notes.where((note) => unassignedFolder.noteIds.contains(note.id)).toList();
    }
    final folder = _folders.firstWhere(
          (f) => f.id == _selectedFolderId,
      orElse: () => Folder(id: null, name: '', noteIds: []),
    );
    return _notes.where((note) => folder.noteIds.contains(note.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: _isMultiSelectMode
          ? AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _cancelMultiSelect,
        ),
        title: Text('${_selectedNotes.length} mục đã chọn'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteSelectedNotes,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chức năng chia sẻ chưa được triển khai')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.visibility_off),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chức năng ẩn chưa được triển khai')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.move_to_inbox),
            onPressed: _moveSelectedNotes,
          ),
        ],
      )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, ${_username ?? 'User'}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _getGreeting(),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm ghi chú',
                        prefixIcon: Icon(
                          Icons.search,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                        hintStyle: TextStyle(
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                      onChanged: (value) => _searchNotes(value.trim()),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.settings,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    onSelected: (value) async {
                      switch (value) {
                        case 'Account':
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AccountScreen()),
                          );
                          await _loadUsername();
                          break;
                        case 'Grid/List':
                          setState(() {
                            _isGridView = !_isGridView;
                          });
                          break;
                        case 'Light/Dark':
                          await Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                          break;
                        case 'Lock out':
                          await _logout();
                          break;
                        case 'Manage Folders':
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const FolderListScreen()),
                          );
                          await _fetchFolders();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'Account', child: Text('Tài khoản')),
                      PopupMenuItem(
                        value: 'Grid/List',
                        child: Text(_isGridView ? 'Chuyển sang danh sách' : 'Chuyển sang lưới'),
                      ),
                      PopupMenuItem(
                        value: 'Light/Dark',
                        child: Text(isDarkMode ? 'Chuyển sang sáng' : 'Chuyển sang tối'),
                      ),
                      const PopupMenuItem(value: 'Manage Folders', child: Text('Quản lý thư mục')),
                      const PopupMenuItem(value: 'Lock out', child: Text('Đăng xuất')),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterTab('Tất cả', 0, null, isDarkMode),
                          const SizedBox(width: 8),
                          ..._folders.asMap().entries.map((entry) {
                            final index = entry.key + 1;
                            final folder = entry.value;
                            if (folder.name == 'Chưa phân loại') {
                              return const SizedBox.shrink(); // Bỏ qua vì sẽ hiển thị riêng
                            }
                            return Row(
                              children: [
                                _buildFilterTab(folder.name, index, folder.id, isDarkMode),
                                const SizedBox(width: 8),
                              ],
                            );
                          }),
                          if (_unassignedFolderId != null)
                            _buildFilterTab(
                                'Chưa phân loại',
                                _folders.length,
                                _unassignedFolderId,
                                isDarkMode),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.create_new_folder,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    onPressed: _createFolder,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Đang tải dữ liệu, vui lòng chờ...',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                )
                    : _errorMessage != null
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchNotes,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
                    : _filteredNotes.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.note,
                        size: 100,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _selectedFolderId == null
                            ? 'Không có ghi chú nào ở đây'
                            : _selectedFolderId == _unassignedFolderId
                            ? 'Không có ghi chú nào trong thư mục "Chưa phân loại"'
                            : 'Không có ghi chú nào trong thư mục này',
                        style: TextStyle(
                          fontSize: 18,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
                    : _isGridView
                    ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: _filteredNotes.length,
                  itemBuilder: (context, index) {
                    final note = _filteredNotes[index];
                    final isSelected = _selectedNotes.contains(note);
                    return NoteItem(
                      note: note,
                      onNoteChanged: () async {
                        await Future.wait([_fetchNotes(), _fetchFolders()]);
                      },
                      onTap: () async {
                        if (_isMultiSelectMode) {
                          _toggleMultiSelect(note);
                        } else {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NoteFormScreen(note: note),
                            ),
                          );
                          if (result == true) {
                            await Future.wait([_fetchNotes(), _fetchFolders()]);
                          }
                        }
                      },
                      onLongPress: () {
                        _toggleMultiSelect(note);
                      },
                      isSelected: isSelected,
                      onSelect: () {
                        _toggleMultiSelect(note);
                      },
                    );
                  },
                )
                    : ListView.builder(
                  itemCount: _filteredNotes.length,
                  itemBuilder: (context, index) {
                    final note = _filteredNotes[index];
                    final isSelected = _selectedNotes.contains(note);
                    return NoteItem(
                      note: note,
                      onNoteChanged: () async {
                        await Future.wait([_fetchNotes(), _fetchFolders()]);
                      },
                      onTap: () async {
                        if (_isMultiSelectMode) {
                          _toggleMultiSelect(note);
                        } else {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NoteFormScreen(note: note),
                            ),
                          );
                          if (result == true) {
                            await Future.wait([_fetchNotes(), _fetchFolders()]);
                          }
                        }
                      },
                      onLongPress: () {
                        _toggleMultiSelect(note);
                      },
                      isSelected: isSelected,
                      onSelect: () {
                        _toggleMultiSelect(note);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteFormScreen()),
          );
          if (result == true) {
            await Future.wait([_fetchNotes(), _fetchFolders()]);
          }
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Ghi chú',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Việc làm',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.orange,
              ),
              child: Text(
                'Thư mục',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.folder_open),
              title: const Text('Tất cả ghi chú'),
              selected: _selectedFolderId == null,
              onTap: () {
                setState(() {
                  _selectedFolderId = null;
                  _selectedFilter = 0;
                });
                Navigator.pop(context);
              },
            ),
            ..._folders.map((folder) => ListTile(
              leading: const Icon(Icons.folder),
              title: Text(folder.name),
              selected: _selectedFolderId == folder.id,
              onTap: () {
                setState(() {
                  _selectedFolderId = folder.id;
                  _selectedFilter = _folders.indexOf(folder) + 1;
                });
                Navigator.pop(context);
              },
              onLongPress: () => _deleteFolder(folder.id!),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String title, int index, String? folderId, bool isDarkMode) {
    return GestureDetector(
      onTap: () => _onFilterTapped(index, folderId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _selectedFilter == index
              ? (isDarkMode ? Colors.grey[800] : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: _selectedFilter == index
                ? (isDarkMode ? Colors.white : Colors.black)
                : (isDarkMode ? Colors.grey[400] : Colors.grey),
            fontWeight: _selectedFilter == index ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}