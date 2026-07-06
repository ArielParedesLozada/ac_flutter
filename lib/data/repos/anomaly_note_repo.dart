import 'package:acl_flutter/data/models/anomaly_note_db.dart';
import 'package:floor/floor.dart';

@dao
abstract class AnomalyNoteRepo {
  @Query('SELECT * FROM anomaly_notes')
  Future<List<AnomalyNoteDb>> getAllAnomalyNotes();

  @Query(
    'SELECT * FROM anomaly_notes WHERE anomaly_notes MATCH :query ORDER BY bm25(anomaly_notes)',
  )
  Future<List<AnomalyNoteDb>> searchNotes(String query);

  @Query(
    'SELECT * FROM anomaly_notes WHERE anomaly_id = :anomalyId ORDER BY created_at',
  )
  Future<List<AnomalyNoteDb>> anomaliesByAnomalyId(int anomalyId);
  @Insert(onConflict: OnConflictStrategy.abort)
  Future<int> createNote(AnomalyNoteDb anomalyNote);

  @Update(onConflict: OnConflictStrategy.abort)
  Future<int> updateNote(AnomalyNoteDb anomalyNote);

  @Query('DELETE FROM anomalies WHERE id = :id')
  Future<void> deleteNote(int id);
}
