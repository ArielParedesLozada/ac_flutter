import 'package:acl_flutter/app/dtos/anomaly_note_create_dto.dart';
import 'package:acl_flutter/data/database.dart';
import 'package:acl_flutter/data/models/anomaly_note_db.dart';
import 'package:acl_flutter/domain/models/anomaly_note.dart';
import 'package:acl_flutter/infrastructure/mapper/anomaly_note_mapper.dart';

class AnomalyNoteService {
  Future<List<AnomalyNote>> getAllAnomalyNotes() async {
    final db = await AppDatabase.instance;
    final anomalyNotesDb = await db.anomalyNoteRepo.getAllAnomalyNotes();
    return anomalyNotesDb.map(AnomalyNoteMapper.fromDb).toList();
  }

  Future<AnomalyNote?> createAnomalyNote(
    AnomalyNoteCreateDto anomalyNoteCreateDto,
  ) async {
    final db = await AppDatabase.instance;
    final anomalyId = anomalyNoteCreateDto.anomalyId;
    final anomaly = await db.anomalyRepo.getAnomalyById(anomalyId);
    if (anomaly == null) {
      throw StateError("Anomaly not found");
    }
    final anomalyNoteDb = AnomalyNoteMapper.fromDomain(
      AnomalyNote(
        anomalyId: anomalyId,
        anomalyName: anomaly.nameSearch,
        content: anomalyNoteCreateDto.content,
        createdAt: DateTime.now(),
        updatedAt: null,
      ),
    );
    final id = await db.anomalyNoteRepo.createNote(anomalyNoteDb);
    return AnomalyNoteMapper.fromDb(
      AnomalyNoteDb(
        id: id,
        anomalyId: anomalyNoteDb.anomalyId,
        anomalyName: anomalyNoteDb.anomalyName,
        content: anomalyNoteDb.content,
        createdAt: anomalyNoteDb.createdAt,
        updatedAt: anomalyNoteDb.createdAt,
      ),
    );
  }

  Future<List<AnomalyNote>> searchNotes(String query) async {
    final db = await AppDatabase.instance;
    final anomalyNotesDb = await db.anomalyNoteRepo.searchNotes(query);
    return anomalyNotesDb.map(AnomalyNoteMapper.fromDb).toList();
  }

  Future<void> deleteNote(AnomalyNote note) async {
    final db = await AppDatabase.instance;
    await db.anomalyNoteRepo.deleteNote(note.id!);
  }
}
