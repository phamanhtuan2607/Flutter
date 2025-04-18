import 'package:flutter/material.dart';
import 'package:app_a02/notesApp/model/Note.dart';
import 'package:app_a02/notesApp/view/NoteForm.dart';


class NoteItem extends StatelessWidget {
  final Note note;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const NoteItem({
    super.key,
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });

  // Hàm xác định màu sắc dựa vào mức độ ưu tiên
  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 3:
        return Colors.red[100]!; // Ưu tiên cao (màu đỏ nhạt)
      case 2:
        return Colors.yellow[100]!; // Ưu tiên trung bình (màu vàng nhạt)
      case 1:
        return Colors.green[100]!; // Ưu tiên thấp (màu xanh nhạt)
      default:
        return Colors.white; // Mặc định màu trắng
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      color: _getPriorityColor(note.priority), // Áp dụng màu theo mức độ ưu tiên
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 1,
      child: InkWell(
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dòng thời gian và nút xóa
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(note.modifiedAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, size: 18,color: Colors.blue),
                    onPressed: () async{
                      final currentNote = await note;
                      if (currentNote != null){
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => NoteFormScreen(note: currentNote),
                      ),);
                      }
                    }),
                  IconButton(
                    icon: Icon(Icons.delete, size: 18, color: Colors.red),
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),

              // Tiêu đề ghi chú
              Text(
                note.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Nội dung ghi chú
              Text(
                note.content,
                style: TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Tags (nếu có)
              if (note.tags != null && note.tags!.isNotEmpty) ...[
                SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  children: note.tags!
                      .map((tag) => Chip(
                    label: Text(
                      tag,
                      style: TextStyle(fontSize: 10),
                    ),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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

  String _formatTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}