import 'package:app_02/noteMS/presentation/screens/note_list/widgets/note_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/model/note.dart';
import '../../../utils/theme_provider.dart';
import '../../providers/note_provider.dart';
import '../note_edit/note_form_screen.dart';
import '../note_detail/note_detail_screen.dart';

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<NoteProvider>(context, listen: false).fetchNotes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách ghi chú'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              if (mounted) {
                noteProvider.fetchNotes();
              }
            },
          ),
          PopupMenuButton<int>(
            onSelected: (priority) {
              if (mounted) {
                noteProvider.filterByPriority(priority);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 1, child: Text('Thấp')),
              PopupMenuItem(value: 2, child: Text('Trung bình')),
              PopupMenuItem(value: 3, child: Text('Cao')),
            ],
            icon: Icon(Icons.filter_list),
          ),
          IconButton(
            icon: Icon(noteProvider.isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              if (mounted) {
                noteProvider.toggleView();
              }
            },
          ),
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              if (mounted) {
                themeProvider.toggleTheme();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm ghi chú...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                if (mounted) {
                  if (query.isEmpty) {
                    noteProvider.fetchNotes();
                  } else {
                    noteProvider.searchNotes(query);
                  }
                }
              },
            ),
          ),
          Expanded(
            child: Consumer<NoteProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (provider.notes.isEmpty) {
                  return Center(child: Text('Chưa có ghi chú nào!'));
                }
                return provider.isGridView
                    ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8, // Tăng chiều cao của ô (chiều cao > chiều rộng)
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: provider.notes.length,
                  itemBuilder: (context, index) {
                    final note = provider.notes[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteDetailScreen(note: note),
                        ),
                      ).then((_) {
                        if (mounted) {
                          provider.fetchNotes();
                        }
                      }),
                      child: NoteItem(
                        note: note,
                        onEdit: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteFormScreen(note: note),
                          ),
                        ).then((_) {
                          if (mounted) {
                            provider.fetchNotes();
                          }
                        }),
                        onDelete: () => _confirmDelete(context, note.id!, provider),
                      ),
                    );
                  },
                )
                    : ListView.builder(
                  itemCount: provider.notes.length,
                  itemBuilder: (context, index) {
                    final note = provider.notes[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteDetailScreen(note: note),
                        ),
                      ).then((_) {
                        if (mounted) {
                          provider.fetchNotes();
                        }
                      }),
                      child: NoteItem(
                        note: note,
                        onEdit: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteFormScreen(note: note),
                          ),
                        ).then((_) {
                          if (mounted) {
                            provider.fetchNotes();
                          }
                        }),
                        onDelete: () => _confirmDelete(context, note.id!, provider),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoteFormScreen()),
        ).then((_) {
          if (mounted) {
            noteProvider.fetchNotes();
          }
        }),
        child: Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id, NoteProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn chắc chắn muốn xóa ghi chú này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteNote(id);
              Navigator.pop(context);
            },
            child: Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}