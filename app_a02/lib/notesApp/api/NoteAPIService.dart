import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/Note.dart';

class NoteAPIService {
  static final NoteAPIService instance = NoteAPIService._init();
  final String baseUrl = 'https://my-json-server.typicode.com/phamanhtuan2607/testflutter';

  NoteAPIService._init();

  // Create - Thêm ghi chú mới
  Future<Note> createNote(Note note) async {
    final response = await http.post(
      Uri.parse('$baseUrl/notes'),
      headers: {'Content-Type': 'application/json'},
      body: note.toJSON(),
    );

    if (response.statusCode == 201) {
      return Note.fromMap(jsonDecode(response.body));    } else {
      throw Exception('Failed to create note: ${response.statusCode}');
    }
  }

  // Read - Đọc tất cả ghi chú
  Future<List<Note>> getAllNotes() async {
    final response = await http.get(Uri.parse('$baseUrl/notes'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Note.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load notes: ${response.statusCode}');
    }
  }

  // Read - Đọc ghi chú theo ID
  Future<Note?> getNoteById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/notes/$id'));

    if (response.statusCode == 200) {
      return Note.fromMap(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to get note: ${response.statusCode}');
    }
  }

  // Update - Cập nhật ghi chú
  Future<Note> updateNote(Note note) async {
    final response = await http.put(
      Uri.parse('$baseUrl/notes/${note.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(note.toMap()),
    );

    if (response.statusCode == 200) {
      return Note.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update note: ${response.statusCode}');
    }
  }

  // Delete - Xoá ghi chú
  Future<bool> deleteNote(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/notes/$id'));

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete note: ${response.statusCode}');
    }
  }

  // Đếm số lượng ghi chú
  Future<int> countNotes() async {
    final notes = await getAllNotes();
    return notes.length;
  }

  // Tìm kiếm ghi chú theo tiêu đề
  Future<List<Note>> searchNotesByTitle(String query) async {
    final notes = await getAllNotes();
    return notes.where((note) =>
        note.title.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Tìm ghi chú theo nội dung
  Future<Note?> getNoteByContent(String content) async {
    final notes = await getAllNotes();
    try {
      return notes.firstWhere((note) => note.content == content);
    } catch (e) {
      return null;
    }
  }

  // Patch - Cập nhật một phần thông tin ghi chú
  Future<Note> patchNote(int id, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/notes/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return Note.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to patch note: ${response.statusCode}');
    }
  }
}
