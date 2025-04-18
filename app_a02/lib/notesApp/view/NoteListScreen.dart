import 'package:flutter/material.dart';
import 'package:app_a02/notesApp/db/NoteDatabaseHelper.dart';
import 'package:app_a02/notesApp/model/Note.dart';
import 'package:app_a02/notesApp/view/NoteDetailScreen.dart';
import 'package:app_a02/notesApp/view/NoteForm.dart';
import 'package:app_a02/notesApp/view/NoteItem.dart';
import 'package:app_a02/notesApp/view/NoteSearchDelegate.dart';
import "package:app_a02/notesApp/api/NoteAPIService.dart";



class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  late Future<List<Note>> notes;
  bool isGridView = false; // Mặc định hiển thị dạng list
  String searchQuery = '';
  int? priorityFilter;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  Future<void> refreshNotes() async {
    setState(() {
      if (searchQuery.isNotEmpty) {
        notes = NoteDatabaseHelper.instance.searchNotes(searchQuery);
      } else if (priorityFilter != null) {
        notes = NoteDatabaseHelper.instance.getNotesByPriority(priorityFilter!);
      } else {
        notes = NoteDatabaseHelper.instance.getAllNotes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách ghi chú'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final query = await showSearch<String?>(
                context: context,
                delegate: NoteSearchDelegate(),
              );
              if (query != null) {
                setState(() {
                  searchQuery = query;
                  refreshNotes();
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Note>>(
        future: notes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return buildListView(snapshot.data!);
          } else {
            return const Center(child: Text('Không tìm thấy ghi chú nào'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteFormScreen(),
            ),
          );
          refreshNotes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildListView(List<Note> notes) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: notes.length,
      itemBuilder: (context, index) => NoteItem(
        note: notes[index],
        onEdit: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteDetailScreen(noteId: notes[index].id!),
            ),
          );
          refreshNotes();
        },
        onDelete: () async {
          await _deleteNote(context, notes[index].id!);
        },
      ),
    );
  }



  Future<void> _deleteNote(BuildContext context, int id) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Xóa ghi chú'),
            content: const Text('Bạn có chắc chắn muốn xóa ghi chú này?'),
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

    if (shouldDelete == true) {
      await NoteDatabaseHelper.instance.deleteNote(id);
      refreshNotes();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xóa ghi chú')),
        );
      }
    }
  }
}
class NoteSearchDelegate extends SearchDelegate<String?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final notesFuture = NoteDatabaseHelper.instance.searchNotes(query);

    return FutureBuilder<List<Note>>(
      future: notesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final note = snapshot.data![index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.content),
                onTap: () {
                  close(context, note.id.toString());
                },
              );
            },
          );
        } else {
          return const Center(child: Text('Không tìm thấy kết quả'));
        }
      },
    );
  }

  @override
  String get searchFieldLabel => 'Tìm kiếm ghi chú';
}
