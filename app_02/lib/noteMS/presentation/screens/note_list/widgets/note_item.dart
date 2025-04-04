import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/model/note.dart';
import '../../../providers/note_provider.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const NoteItem({
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });

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
        : theme.cardColor;
    final textColor = _getContrastingTextColor(cardColor);

    return Card(
      color: cardColor,
      child: Stack(
        children: [
          // Nội dung chính của NoteItem
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(bottom: 40), // Thêm padding dưới để chừa chỗ cho icon
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
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            decoration: note.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    note.content,
                    style: TextStyle(
                      color: textColor,
                      decoration: note.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  if (note.imagePath != null) ...[
                    Container(
                      width: 80,
                      height: 80,
                      child: Image.file(
                        File(note.imagePath!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.broken_image,
                          color: textColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                  ],
                  Text(
                    'Tạo: ${note.createdAt.toString().substring(0, 16)}',
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Sửa: ${note.modifiedAt.toString().substring(0, 16)}',
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  if (note.tags != null && note.tags!.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: note.tags!.take(3).map((tag) => Chip(
                        label: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 10,
                            color: textColor,
                          ),
                        ),
                        backgroundColor: textColor.withOpacity(0.1),
                      )).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Hai icon Edit và Delete
          Positioned(
            bottom: 8,
            right: 8,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: _getPriorityColor(note.priority, theme.brightness),
                    size: 20,
                  ),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 20,
                  ),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}