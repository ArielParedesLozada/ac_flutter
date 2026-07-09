import 'package:floor/floor.dart';
import 'package:acl_flutter/data/models/topic_db.dart';

@Entity(
  tableName: 'topic_notes',
  foreignKeys: [
    ForeignKey(
      childColumns: ['topic_id'],
      parentColumns: ['id'],
      entity: TopicDb,
    ),
  ],
)
class TopicNoteDb {
  @primaryKey
  final int? id;
  @ColumnInfo(name: 'topic_id')
  final int topicId;
  @ColumnInfo(name: 'topic_name')
  final String topicName;
  @ColumnInfo(name: 'content')
  final String content;
  @ColumnInfo(name: 'start_date')
  final String? startDate;
  @ColumnInfo(name: 'end_date')
  final String? endDate;
  @ColumnInfo(name: 'related_entity_id')
  final int? relatedEntityId;

  TopicNoteDb({
    this.id,
    required this.topicId,
    required this.topicName,
    required this.content,
    this.startDate,
    this.endDate,
    this.relatedEntityId,
  });
}
