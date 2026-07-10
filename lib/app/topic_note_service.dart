import 'package:acl_flutter/app/dtos/topic_note_create_dto.dart';
import 'package:acl_flutter/app/dtos/topic_note_update_dto.dart';
import 'package:acl_flutter/data/database.dart';
import 'package:acl_flutter/data/models/topic_note_db.dart';
import 'package:acl_flutter/domain/models/topic_note.dart';
import 'package:acl_flutter/infrastructure/mapper/topic_note_mapper.dart';
import 'package:acl_flutter/infrastructure/notifications/notification_service.dart';

class TopicNoteService {
  Future<List<TopicNote>> getAllTopicNotes() async {
    final db = await AppDatabase.instance;
    final notesDb = await db.topicNoteRepo.getAllTopicNotes();
    return notesDb.map(TopicNoteMapper.fromDb).toList();
  }

  Future<List<TopicNote>> getNotesByTopicId(int topicId) async {
    final db = await AppDatabase.instance;
    final notesDb = await db.topicNoteRepo.getNotesByTopicId(topicId);
    return notesDb.map(TopicNoteMapper.fromDb).toList();
  }

  Future<List<TopicNote>> searchNotes(String query) async {
    final db = await AppDatabase.instance;
    final notesDb = await db.topicNoteRepo.searchNotes(query);
    return notesDb.map(TopicNoteMapper.fromDb).toList();
  }

  Future<TopicNote> createNote(TopicNoteCreateDto dto) async {
    final db = await AppDatabase.instance;
    final topicDb = await db.topicRepo.getTopicById(dto.topicId);
    if (topicDb == null) throw StateError('Topic not found');
    final noteDb = TopicNoteMapper.fromDomain(
      TopicNote(
        topicId: dto.topicId,
        topicName: topicDb.name,
        content: dto.content,
        startDate: dto.startDate,
        endDate: dto.endDate,
        relatedEntityId: dto.relatedEntityId,
      ),
    );
    final id = await db.topicNoteRepo.createNote(noteDb);
    final created = TopicNoteMapper.fromDb(
      TopicNoteDb(
        id: id,
        topicId: noteDb.topicId,
        topicName: noteDb.topicName,
        content: noteDb.content,
        startDate: noteDb.startDate,
        endDate: noteDb.endDate,
        relatedEntityId: noteDb.relatedEntityId,
      ),
    );
    await NotificationService.scheduleNotificationForTopicNote(created);
    return created;
  }

  Future<void> updateNote(TopicNote note, TopicNoteUpdateDto dto) async {
    final db = await AppDatabase.instance;
    final updatedNote = TopicNote(
      id: note.id,
      topicId: note.topicId,
      topicName: note.topicName,
      content: dto.content ?? note.content,
      startDate: dto.startDate ?? note.startDate,
      endDate: dto.endDate ?? note.endDate,
      relatedEntityId: dto.relatedEntityId ?? note.relatedEntityId,
    );
    await db.topicNoteRepo.updateNote(TopicNoteMapper.fromDomain(updatedNote));
    await NotificationService.updateNotificationForNote(updatedNote);
  }

  Future<void> deleteNote(TopicNote note) async {
    await NotificationService.cancelNotificationsForNote(note);
    final db = await AppDatabase.instance;
    await db.topicNoteRepo.deleteNote(note.id!);
  }
}
