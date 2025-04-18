import 'package:flutter/material.dart';
import 'package:app_a02/notesApp/model/Note.dart';
import 'package:app_a02/notesApp/view/NoteForm.dart';
import 'package:app_a02/notesApp/db/NoteDatabaseHelper.dart';


class NoteDetailScreen extends StatefulWidget {
  final int noteId;

  const NoteDetailScreen({super.key, required this.noteId});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late Future<Note?> note;

  @override
  void initState() {
    super.initState();
    note = NoteDatabaseHelper.instance.getNoteById(widget.noteId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết ghi chú'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final currentNote = await note;
              if (currentNote != null) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteFormScreen(note: currentNote),
                  ),
                );
                setState(() {
                  note = NoteDatabaseHelper.instance.getNoteById(widget.noteId);
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Note?>(
        future: note,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            return _buildNoteDetail(snapshot.data!);
          } else {
            return const Center(child: Text('Không tìm thấy ghi chú'));
          }
        },
      ),
    );
  }

  Widget _buildNoteDetail(Note note) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            note.content,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          if (note.tags != null && note.tags!.isNotEmpty) ...[
            const Text(
              'Nhãn:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: note.tags!
                  .map((tag) => Chip(label: Text(tag)))
                  .toList(),
            ),
            const SizedBox(height: 16),
          ],
          const Divider(),
          const SizedBox(height: 8),
          Text(
            'Tạo lúc: ${_formatDateTime(note.createdAt)}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            'Cập nhật lúc: ${_formatDateTime(note.modifiedAt)}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')} ${date.day}/${date.month}/${date.year}';
  }
}