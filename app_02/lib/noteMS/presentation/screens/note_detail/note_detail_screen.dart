import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/model/note.dart';
import '../note_edit/note_form_screen.dart';
import '../../providers/note_provider.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  const NoteDetailScreen({required this.note});

  Color _getPriorityColor(int priority, Brightness brightness) {
    switch (priority) {
      case 1:
        return brightness == Brightness.dark ? Colors.green[300]! : Colors.green;
      case 2:
        return brightness == Brightness.dark ? Colors.orange[300]! : Colors.orange;
      case 3:
        return brightness == Brightness.dark ? Colors.red[300]! : Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getContrastingTextColor(Color backgroundColor) {
    final luminance = (0.299 * backgroundColor.red +
        0.587 * backgroundColor.green +
        0.114 * backgroundColor.blue) /
        255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final cardColor = note.color != null
        ? Color(int.parse('0xff${note.color}'))
        : Colors.transparent;
    final textColor = _getContrastingTextColor(cardColor);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết ghi chú'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteFormScreen(note: note),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: note.isCompleted,
                    onChanged: (value) {
                      if (value != null) {
                        noteProvider.toggleCompleted(note.id!, value);
                      }
                    },
                  ),
                  Expanded(
                    child: Text(
                      note.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyMedium!.color,
                        decoration: note.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  note.content,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    decoration: note.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 16),
              if (note.imagePath != null) ...[
                Text(
                  'Ảnh đính kèm:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyMedium!.color,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 200,
                  child: Image.file(
                    File(note.imagePath!),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.broken_image,
                      color: textColor.withOpacity(0.5),
                      size: 50,
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
              Row(
                children: [
                  Text(
                    'Ưu tiên: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyMedium!.color,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(note.priority, theme.brightness),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      note.priority == 1
                          ? 'Thấp'
                          : note.priority == 2
                          ? 'Trung bình'
                          : 'Cao',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Tạo lúc: ${note.createdAt.toString().substring(0, 16)}',
                style: theme.textTheme.bodySmall,
              ),
              Text(
                'Sửa lúc: ${note.modifiedAt.toString().substring(0, 16)}',
                style: theme.textTheme.bodySmall,
              ),
              SizedBox(height: 16),
              if (note.tags != null && note.tags!.isNotEmpty) ...[
                Text(
                  'Nhãn:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyMedium!.color,
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: note.tags!
                      .map((tag) => Chip(
                    label: Text(tag),
                  ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}