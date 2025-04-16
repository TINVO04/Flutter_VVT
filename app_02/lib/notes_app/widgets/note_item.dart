import 'package:flutter/material.dart';
import '../data/note.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  final VoidCallback onNoteChanged;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isSelected;
  final VoidCallback onSelect;

  const NoteItem({
    super.key,
    required this.note,
    required this.onNoteChanged,
    required this.onTap,
    required this.onLongPress,
    required this.isSelected,
    required this.onSelect,
  });

  String _getFormattedDateTime() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final noteDate = DateTime(
      note.modifiedAt.year,
      note.modifiedAt.month,
      note.modifiedAt.day,
    );

    final hour = note.modifiedAt.hour % 12 == 0 ? 12 : note.modifiedAt.hour % 12;
    final minute = note.modifiedAt.minute.toString().padLeft(2, '0');
    final period = note.modifiedAt.hour >= 12 ? 'CH' : 'SA';

    if (noteDate == today) {
      return 'Hôm nay $hour:$minute $period';
    } else if (noteDate == today.subtract(const Duration(days: 1))) {
      return 'Hôm qua $hour:$minute $period';
    } else {
      return '${note.modifiedAt.day} Tháng ${note.modifiedAt.month}, ${note.modifiedAt.year} $hour:$minute $period';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: isSelected ? onSelect : onTap,
      onLongPress: onLongPress,
      child: Card(
        color: isSelected
            ? (isDarkMode ? Colors.grey[600] : Colors.grey[300])
            : Theme.of(context).cardColor,
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getFormattedDateTime(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (note.isCompleted)
                Icon(
                  Icons.check_circle,
                  color: isDarkMode ? Colors.yellow[700] : Colors.yellow,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}