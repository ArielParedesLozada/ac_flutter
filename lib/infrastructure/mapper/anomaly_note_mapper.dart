import 'package:acl_flutter/data/models/anomaly_note_db.dart';
import 'package:acl_flutter/domain/models/anomaly_note.dart';

class AnomalyNoteMapper {
  static AnomalyNote fromDb(AnomalyNoteDb db) {
    return AnomalyNote(
      id: db.id,
      anomalyId: db.anomalyId,
      anomalyName: db.anomalyName,
      content: db.content,
      createdAt: DateTime.parse(db.createdAt),
      updatedAt: db.updatedAt != null ? DateTime.parse(db.updatedAt!) : null,
    );
  }

  static AnomalyNoteDb fromDomain(AnomalyNote note) {
    return AnomalyNoteDb(
      id: note.id,
      anomalyId: note.anomalyId,
      anomalyName: note.anomalyName,
      content: note.content,
      createdAt: note.createdAt.toIso8601String(),
      updatedAt: note.updatedAt?.toIso8601String(),
    );
  }
}
