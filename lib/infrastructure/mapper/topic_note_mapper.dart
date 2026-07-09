import 'package:acl_flutter/data/models/topic_note_db.dart';
import 'package:acl_flutter/domain/models/topic_note.dart';

class TopicNoteMapper {
  static TopicNote fromDb(TopicNoteDb db) {
    return TopicNote(
      id: db.id,
      topicId: db.topicId,
      topicName: db.topicName,
      content: db.content,
      startDate: db.startDate != null ? DateTime.parse(db.startDate!) : null,
      endDate: db.endDate != null ? DateTime.parse(db.endDate!) : null,
      relatedEntityId: db.relatedEntityId,
    );
  }

  static TopicNoteDb fromDomain(TopicNote note) {
    return TopicNoteDb(
      id: note.id,
      topicId: note.topicId,
      topicName: note.topicName,
      content: note.content,
      startDate: note.startDate?.toIso8601String(),
      endDate: note.endDate?.toIso8601String(),
      relatedEntityId: note.relatedEntityId,
    );
  }
}
