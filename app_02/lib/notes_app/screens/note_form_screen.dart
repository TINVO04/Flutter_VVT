import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../api/note_api_service.dart';
import '../data/note.dart';
import '../data/folder.dart';
import '../utils/theme_provider.dart';
import '../widgets/color_picker_dialog.dart';

class NoteFormScreen extends StatefulWidget {
  final Note? note;

  const NoteFormScreen({super.key, this.note});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  int _priority = 1;
  String? _color;
  bool _isCompleted = false;
  String? _selectedFolderId;
  final List<String> _imagePaths = [];
  final List<String> _originalImagePaths = [];
  final List<File> _selectedImages = [];
  final List<bool> _isResized = [];
  final List<bool> _hasResizedFile = [];
  final NoteApiService _apiService = NoteApiService();
  final ImagePicker _picker = ImagePicker();
  static const int _maxImages = 10;
  final Map<String, String> _imageDescriptions = {};
  List<Folder> _folders = [];

  @override
  void initState() {
    super.initState();
    _loadFolders();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _priority = widget.note!.priority;
      _color = widget.note!.color;
      _isCompleted = widget.note!.isCompleted;
      _selectedFolderId = widget.note!.folderId;
      if (widget.note!.imagePaths != null) {
        _imagePaths.addAll(widget.note!.imagePaths!);
        _originalImagePaths.addAll(widget.note!.imagePaths!);
        _selectedImages.addAll(_imagePaths.map((path) => File(path)));
        _isResized.addAll(List.generate(_imagePaths.length, (_) => false));
        _hasResizedFile.addAll(List.generate(_imagePaths.length, (_) => false));
      }
    }
  }

  Future<void> _loadFolders() async {
    try {
      final folders = await _apiService.getAllFolders();
      setState(() {
        _folders = folders;
        // Nếu _selectedFolderId không còn tồn tại trong danh sách thư mục, đặt lại về null
        if (_selectedFolderId != null &&
            !_folders.any((folder) => folder.id == _selectedFolderId)) {
          _selectedFolderId = null;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải thư mục: $e')),
      );
    }
  }

  Future<bool> _requestPermission(ImageSource source) async {
    final permission = source == ImageSource.camera ? Permission.camera : Permission.photos;
    final status = await permission.request();
    return status.isGranted;
  }

  Future<void> _pickImage() async {
    if (_selectedImages.length >= _maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn chỉ có thể thêm tối đa 10 hình ảnh')),
      );
      return;
    }

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Thư viện'),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );

    if (source != null && await _requestPermission(source)) {
      try {
        final pickedFile = await _picker.pickImage(source: source);
        if (pickedFile != null) {
          setState(() {
            _imagePaths.add(pickedFile.path);
            _originalImagePaths.add(pickedFile.path);
            _selectedImages.add(File(pickedFile.path));
            _isResized.add(false);
            _hasResizedFile.add(false);
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi chọn ảnh: $e')),
        );
      }
    }
  }

  Future<void> _resizeImage(int index) async {
    if (_isResized[index]) {
      setState(() {
        _isResized[index] = false;
        _selectedImages[index] = File(_originalImagePaths[index]);
        _imagePaths[index] = _originalImagePaths[index];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã khôi phục kích thước ảnh')),
      );
    } else {
      if (!_hasResizedFile[index]) {
        try {
          final file = File(_originalImagePaths[index]);
          final imageBytes = await file.readAsBytes();
          final image = img.decodeImage(imageBytes);

          if (image == null) {
            throw Exception('Không thể đọc ảnh');
          }

          final resizedImage = img.copyResize(image, width: image.width ~/ 2);
          final tempDir = await getTemporaryDirectory();
          final resizedFile = File(
              '${tempDir.path}/resized_${DateTime.now().millisecondsSinceEpoch}.jpg');
          await resizedFile.writeAsBytes(img.encodeJpg(resizedImage, quality: 90));

          setState(() {
            _imagePaths[index] = resizedFile.path;
            _selectedImages[index] = resizedFile;
            _hasResizedFile[index] = true;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã thu nhỏ ảnh thành công')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi khi thu nhỏ ảnh: $e')),
          );
          return;
        }
      }
      setState(() {
        _isResized[index] = true;
      });
    }
  }

  void _deleteImage(int index) {
    setState(() {
      final imagePath = _imagePaths.removeAt(index);
      _originalImagePaths.removeAt(index);
      _selectedImages.removeAt(index);
      _isResized.removeAt(index);
      _hasResizedFile.removeAt(index);
      _imageDescriptions.remove(imagePath);
    });
  }

  void _viewFullScreen(File image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: PhotoView(
            imageProvider: FileImage(image),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(Icons.broken_image, color: Colors.white, size: 100),
            ),
          ),
        ),
      ),
    );
  }

  void _addDescription(int index) async {
    final imagePath = _imagePaths[index];
    final descriptionController = TextEditingController(
      text: _imageDescriptions[imagePath] ?? '',
    );
    final description = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mô tả ảnh'),
        content: TextField(
          controller: descriptionController,
          decoration: const InputDecoration(hintText: 'Nhập mô tả...'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, descriptionController.text),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );

    if (description != null && description.isNotEmpty) {
      setState(() {
        _imageDescriptions[imagePath] = description;
      });
    }
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _titleController.text = _titleController.text.trim();
        _contentController.text = _contentController.text.trim();
      });

      final note = Note(
        id: widget.note?.id,
        title: _titleController.text,
        content: _contentController.text,
        priority: _priority,
        createdAt: widget.note?.createdAt ?? DateTime.now(),
        modifiedAt: DateTime.now(),
        color: _color,
        isCompleted: _isCompleted,
        imagePaths: _imagePaths.isEmpty ? null : _imagePaths,
        folderId: _selectedFolderId,
      );

      try {
        Note savedNote;
        if (widget.note == null) {
          savedNote = await _apiService.insertNote(note);
          if (savedNote.id == null) {
            throw Exception('ID của ghi chú mới không hợp lệ');
          }
          final folderId = _selectedFolderId ?? await _apiService.ensureDefaultFolder();
          await _apiService.addNoteToFolder(savedNote.id!, folderId);
        } else {
          await _apiService.updateNote(note);
          savedNote = note;
          if (savedNote.id == null) {
            throw Exception('ID của ghi chú cập nhật không hợp lệ');
          }
          if (_selectedFolderId != widget.note!.folderId) {
            if (widget.note!.folderId != null) {
              await _apiService.removeNoteFromFolder(savedNote.id!, widget.note!.folderId!);
            }
            if (_selectedFolderId != null) {
              await _apiService.addNoteToFolder(savedNote.id!, _selectedFolderId!);
            } else {
              final defaultFolderId = await _apiService.ensureDefaultFolder();
              await _apiService.addNoteToFolder(savedNote.id!, defaultFolderId);
            }
          }
        }
        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi lưu ghi chú: $e')),
        );
      }
    }
  }

  Future<void> _deleteNote() async {
    if (widget.note != null) {
      try {
        if (widget.note!.folderId != null) {
          await _apiService.removeNoteFromFolder(widget.note!.id!, widget.note!.folderId!);
        }
        await _apiService.deleteNote(widget.note!.id!);
        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi xóa ghi chú: $e')),
        );
      }
    }
  }

  String _getFormattedDateTime() {
    final now = widget.note?.modifiedAt ?? DateTime.now();
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'CH' : 'SA';
    return '${now.day} Tháng ${now.month} $hour:$minute $period';
  }

  Color? _parseColor(String? color) {
    try {
      if (color == null) return null;
      return Color(int.parse(color.replaceFirst('#', ''), radix: 16) | 0xFF000000);
    } catch (e) {
      return null;
    }
  }

  Color _getTextColor(Color backgroundColor) {
    final luminance = (0.299 * backgroundColor.red +
        0.587 * backgroundColor.green +
        0.114 * backgroundColor.blue) /
        255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final backgroundColor = _parseColor(_color) ??
        (isDarkMode ? Theme.of(context).scaffoldBackgroundColor : const Color(0xFFF3E5F5));
    final textColor = _getTextColor(backgroundColor);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: textColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _getFormattedDateTime(),
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.share,
              color: textColor,
            ),
            onSelected: (value) {
              switch (value) {
                case 'Nhắc nhở':
                case 'Ẩn':
                case 'Thêm vào màn hình chính':
                case 'Chuyển tới':
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Chức năng $value chưa được triển khai')),
                  );
                  break;
                case 'Xóa':
                  _deleteNote();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Nhắc nhở', child: Text('Nhắc nhở')),
              const PopupMenuItem(value: 'Ẩn', child: Text('Ẩn')),
              const PopupMenuItem(
                  value: 'Thêm vào màn hình chính',
                  child: Text('Thêm vào màn hình chính')),
              const PopupMenuItem(value: 'Chuyển tới', child: Text('Chuyển tới')),
              const PopupMenuItem(value: 'Xóa', child: Text('Xóa')),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.check,
              color: textColor,
            ),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Tiêu đề',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: textColor.withOpacity(0.6),
                  ),
                ),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _contentController,
                        decoration: InputDecoration(
                          hintText: 'Bắt đầu nhập...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: textColor.withOpacity(0.6),
                          ),
                        ),
                        style: TextStyle(
                          color: textColor,
                        ),
                        maxLines: null,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập nội dung';
                          }
                          return null;
                        },
                      ),
                      if (_selectedImages.isNotEmpty) ...[
                        Column(
                          children: List.generate(_selectedImages.length, (index) {
                            final imagePath = _imagePaths[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => Container(
                                        color: Colors.black87,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.fullscreen, color: Colors.white),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _viewFullScreen(_selectedImages[index]);
                                              },
                                              tooltip: 'Xem toàn màn hình',
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.description, color: Colors.white),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _addDescription(index);
                                              },
                                              tooltip: 'Mô tả ảnh',
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                _isResized[index] ? Icons.zoom_in : Icons.zoom_out,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _resizeImage(index);
                                              },
                                              tooltip: _isResized[index] ? 'Khôi phục' : 'Thu nhỏ',
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete, color: Colors.white),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _deleteImage(index);
                                              },
                                              tooltip: 'Xóa',
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Image.file(
                                      _selectedImages[index],
                                      width: _isResized[index]
                                          ? (MediaQuery.of(context).size.width - 32) * 0.5
                                          : MediaQuery.of(context).size.width - 32,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Icon(
                                        Icons.broken_image,
                                        size: 100,
                                      ),
                                    ),
                                  ),
                                ),
                                if (_imageDescriptions.containsKey(imagePath) &&
                                    _imageDescriptions[imagePath]!.isNotEmpty) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      _imageDescriptions[imagePath]!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: textColor.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            );
                          }),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        color: textColor,
                      ),
                      onPressed: _pickImage,
                      tooltip: 'Chọn ảnh',
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.color_lens,
                        color: textColor,
                      ),
                      onPressed: () async {
                        final selectedColor = await showDialog<String>(
                          context: context,
                          builder: (context) => const ColorPickerDialog(),
                        );
                        if (selectedColor != null) {
                          setState(() {
                            _color = selectedColor;
                          });
                        }
                      },
                      tooltip: 'Chọn màu',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Ưu tiên: ',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                          ),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 120),
                          child: DropdownButton<int>(
                            value: _priority,
                            isExpanded: true,
                            items: [
                              DropdownMenuItem(
                                value: 1,
                                child: Text(
                                  'Thấp',
                                  style: TextStyle(color: textColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text(
                                  'Trung bình',
                                  style: TextStyle(color: textColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              DropdownMenuItem(
                                value: 3,
                                child: Text(
                                  'Cao',
                                  style: TextStyle(color: textColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _priority = value;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Ưu tiên ${value == 3 ? "cao vãi" : value == 2 ? "tạm ổn" : "lẹt đẹt"} nha anh!',
                                    ),
                                  ),
                                );
                              }
                            },
                            dropdownColor: backgroundColor,
                            underline: Container(),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Thư mục: ',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                          ),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 150),
                          child: DropdownButton<String>(
                            value: _selectedFolderId,
                            hint: Text(
                              'Chọn thư mục',
                              style: TextStyle(color: textColor.withOpacity(0.6)),
                              overflow: TextOverflow.ellipsis,
                            ),
                            isExpanded: true,
                            items: [
                              DropdownMenuItem(
                                value: null,
                                child: Text(
                                  'Không thư mục',
                                  style: TextStyle(color: textColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ..._folders.map((folder) => DropdownMenuItem(
                                value: folder.id,
                                child: Text(
                                  folder.name,
                                  style: TextStyle(color: textColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedFolderId = value;
                              });
                            },
                            dropdownColor: backgroundColor,
                            underline: Container(),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        _isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                        color: textColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isCompleted = !_isCompleted;
                        });
                      },
                      tooltip: 'Hoàn thành',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}