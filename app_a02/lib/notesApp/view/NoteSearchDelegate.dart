import 'package:flutter/material.dart';
import 'package:app_a02/notesApp/db/NoteDatabaseHelper.dart';
import 'package:app_a02/notesApp/model/Note.dart';

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
    if (query.isEmpty) {
      return const Center(
        child: Text('Nhập từ khóa để tìm kiếm ghi chú'),
      );
    }

    final notesFuture = NoteDatabaseHelper.instance.searchNotes(query);

    return FutureBuilder<List<Note>>(
      future: notesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final note = snapshot.data![index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.content.length > 50
                    ? '${note.content.substring(0, 50)}...'
                    : note.content),
                onTap: () {
                  close(context, query);
                },
              );
            },
          );
        } else {
          return const Center(child: Text('Không tìm thấy ghi chú phù hợp'));
        }
      },
    );
  }

  @override
  String get searchFieldLabel => 'Tìm kiếm ghi chú...';
}