import 'package:acl_flutter/app/dtos/topic_create_dto.dart';
import 'package:acl_flutter/app/dtos/topic_update_dto.dart';
import 'package:acl_flutter/data/database.dart';
import 'package:acl_flutter/data/models/topic_db.dart';
import 'package:acl_flutter/domain/models/topic.dart';
import 'package:acl_flutter/infrastructure/mapper/topic_mapper.dart';

class TopicService {
  Future<List<Topic>> getAllTopics() async {
    final db = await AppDatabase.instance;
    final topicsDb = await db.topicRepo.getAllTopics();
    return topicsDb.map(TopicMapper.fromDb).toList();
  }

  Future<List<Topic>> searchTopics(String query) async {
    final db = await AppDatabase.instance;
    final topicsDb = await db.topicRepo.searchTopics('%$query%');
    return topicsDb.map(TopicMapper.fromDb).toList();
  }

  Future<Topic?> getTopicById(int id) async {
    final db = await AppDatabase.instance;
    final topicDb = await db.topicRepo.getTopicById(id);
    return topicDb != null ? TopicMapper.fromDb(topicDb) : null;
  }

  Future<Topic> createTopic(TopicCreateDto dto) async {
    final db = await AppDatabase.instance;
    final topicDb = TopicMapper.fromDomain(
      Topic(
        name: dto.name,
        description: dto.description,
        startDate: dto.startDate,
        endDate: dto.endDate,
      ),
    );
    final id = await db.topicRepo.createTopic(topicDb);
    return TopicMapper.fromDb(
      TopicDb(
        id: id,
        name: topicDb.name,
        description: topicDb.description,
        startDate: topicDb.startDate,
        endDate: topicDb.endDate,
      ),
    );
  }

  Future<Topic> updateTopic(int id, TopicUpdateDto dto) async {
    final db = await AppDatabase.instance;
    final existingDb = await db.topicRepo.getTopicById(id);
    if (existingDb == null) throw StateError('Topic not found');
    final existing = TopicMapper.fromDb(existingDb);
    final updated = TopicMapper.fromDomain(
      Topic(
        id: id,
        name: dto.name ?? existing.name,
        description: dto.description ?? existing.description,
        startDate: dto.startDate ?? existing.startDate,
        endDate: dto.endDate ?? existing.endDate,
      ),
    );
    await db.topicRepo.updateTopic(updated);
    return TopicMapper.fromDb(updated);
  }

  Future<void> deleteTopic(int id) async {
    final db = await AppDatabase.instance;
    await db.topicRepo.deleteTopic(id);
  }
}
