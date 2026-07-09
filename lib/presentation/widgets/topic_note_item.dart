import 'package:acl_flutter/domain/models/topic_note.dart';
import 'package:flutter/material.dart';

class TopicNoteItem extends StatelessWidget {
  final TopicNote topicNote;
  const TopicNoteItem({super.key, required this.topicNote});

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: const Color.fromARGB(255, 202, 219, 255),
      leading: const Icon(Icons.task_alt),
      title: Text(topicNote.content),
      subtitle: topicNote.endDate != null
          ? Text('Hasta: ${_formatDate(topicNote.endDate!)}')
          : null,
    );
  }
}
