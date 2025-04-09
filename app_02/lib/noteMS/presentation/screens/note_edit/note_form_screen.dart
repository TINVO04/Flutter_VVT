import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../data/model/note.dart';
import '../../providers/note_provider.dart';

class NoteFormScreen extends StatefulWidget {
  final Note? note;

  const NoteFormScreen({this.note});

  @override
  _NoteFormScreenState createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late int _priority;
  late Color _selectedColor;
  String? _imagePath;

  final List<Color> _colorOptions = [
    Colors.white,
    Colors.grey[800]!,
    Colors.red[300]!,
    Colors.pink[300]!,
    Colors.purple[300]!,
    Colors.deepPurple[300]!,
    Colors.indigo[300]!,
    Colors.blue[300]!,
    Colors.cyan[300]!,
    Colors.teal[300]!,
    Colors.green[300]!,
    Colors.yellow[300]!,
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _priority = widget.note?.priority ?? 1;
    _imagePath = widget.note?.imagePath;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedColor = widget.note?.color != null
        ? Color(int.parse('0xff${widget.note!.color}'))
        : Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[800]!
        : Colors.white;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final permissionStatus = await Permission.photos.request();
    if (permissionStatus.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
        final newPath = '${appDir.path}/$fileName';
        await File(pickedFile.path).copy(newPath);
        setState(() {
          _imagePath = newPath;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cần cấp quyền truy cập thư viện ảnh để chọn ảnh')),
      );
    }
  }

  void _removeImage() async {
    if (_imagePath != null) {
      final file = File(_imagePath!);
      if (await file.exists()) {
        await file.delete();
      }
      setState(() {
        _imagePath = null;
      });
    }
  }

  void _saveNote(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final noteProvider = Provider.of<NoteProvider>(context, listen: false);
      final newNote = Note(
        id: widget.note?.id,
        title: _titleController.text,
        content: _contentController.text,
        priority: _priority,
        createdAt: widget.note?.createdAt ?? now,
        modifiedAt: now,
        color: _selectedColor.value.toRadixString(16).substring(2),
        isCompleted: widget.note?.isCompleted ?? false,
        imagePath: _imagePath,
      );

      try {
        if (widget.note == null) {
          await noteProvider.repository.insertNote(newNote);
        } else {
          if (widget.note?.imagePath != null && _imagePath != widget.note?.imagePath) {
            final oldFile = File(widget.note!.imagePath!);
            if (await oldFile.exists()) {
              await oldFile.delete();
            }
          }
          await noteProvider.repository.updateNote(newNote);
        }
        await noteProvider.fetchNotes();
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi lưu ghi chú: $e')),
        );
      }
    }
  }

  void _showColorPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chọn màu'),
        content: Container(
          width: double.maxFinite,
          height: 200,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: _colorOptions.length,
            itemBuilder: (context, index) {
              final color = _colorOptions[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = color;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    border: Border.all(
                      color: _selectedColor == color ? Colors.black : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Thêm ghi chú' : 'Sửa ghi chú'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Tiêu đề'),
                  style: TextStyle(color: theme.textTheme.bodyMedium!.color),
                  validator: (value) =>
                  value!.isEmpty ? 'Tiêu đề không được để trống' : null,
                ),
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(labelText: 'Nội dung'),
                  style: TextStyle(color: theme.textTheme.bodyMedium!.color),
                  maxLines: 5,
                  validator: (value) =>
                  value!.isEmpty ? 'Nội dung không được để trống' : null,
                ),
                SizedBox(height: 16),
                Text('Mức độ ưu tiên', style: TextStyle(color: theme.textTheme.bodyMedium!.color)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Radio<int>(
                      value: 1,
                      groupValue: _priority,
                      onChanged: (value) => setState(() => _priority = value!),
                    ),
                    Text('Thấp', style: TextStyle(color: theme.textTheme.bodyMedium!.color)),
                    Radio<int>(
                      value: 2,
                      groupValue: _priority,
                      onChanged: (value) => setState(() => _priority = value!),
                    ),
                    Text('Trung bình', style: TextStyle(color: theme.textTheme.bodyMedium!.color)),
                    Radio<int>(
                      value: 3,
                      groupValue: _priority,
                      onChanged: (value) => setState(() => _priority = value!),
                    ),
                    Text('Cao', style: TextStyle(color: theme.textTheme.bodyMedium!.color)),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text('Màu sắc: ', style: TextStyle(color: theme.textTheme.bodyMedium!.color)),
                    GestureDetector(
                      onTap: () => _showColorPickerDialog(context),
                      child: Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: _selectedColor,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text('Đính kèm ảnh', style: TextStyle(color: theme.textTheme.bodyMedium!.color)),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Chọn ảnh'),
                    ),
                    SizedBox(width: 16),
                    if (_imagePath != null)
                      Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            child: Image.file(
                              File(_imagePath!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.broken_image,
                                color: theme.textTheme.bodyMedium!.color,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _removeImage,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _saveNote(context),
                  child: Text(widget.note == null ? 'Thêm' : 'Cập nhật'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}