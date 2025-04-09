import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/model/note.dart';
import '../../../utils/theme_provider.dart';
import '../../providers/note_provider.dart';
import '../note_edit/note_form_screen.dart';
import '../note_detail/note_detail_screen.dart';
import 'widgets/note_item.dart';

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
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: provider.notes.length,
                  itemBuilder: (context, index) {
                    final note = provider.notes[index];
                    return NoteItem(note: note);
                  },
                )
                    : ListView.builder(
                  itemCount: provider.notes.length,
                  itemBuilder: (context, index) {
                    final note = provider.notes[index];
                    return NoteItem(note: note);
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
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}