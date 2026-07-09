import 'package:acl_flutter/data/models/topic_note_db.dart';
import 'package:floor/floor.dart';

@dao
abstract class TopicNoteRepo {
  @Query('SELECT * FROM topic_notes')
  Future<List<TopicNoteDb>> getAllTopicNotes();

  @Query('SELECT * FROM topic_notes WHERE topic_id = :topicId ORDER BY start_date')
  Future<List<TopicNoteDb>> getNotesByTopicId(int topicId);

  @Query(
    'SELECT tn.* FROM topic_notes tn '
    'INNER JOIN topic_notes_fts fts ON tn.id = fts.docid '
    'WHERE topic_notes_fts MATCH :query '
    'ORDER BY CASE WHEN tn.end_date IS NULL THEN 1 ELSE 0 END, tn.end_date ASC',
  )
  Future<List<TopicNoteDb>> searchNotes(String query);

  @Insert(onConflict: OnConflictStrategy.abort)
  Future<int> createNote(TopicNoteDb note);

  @Update(onConflict: OnConflictStrategy.abort)
  Future<int> updateNote(TopicNoteDb note);

  @Query('DELETE FROM topic_notes WHERE id = :id')
  Future<void> deleteNote(int id);
}
