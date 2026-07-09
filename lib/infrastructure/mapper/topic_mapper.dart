import 'package:acl_flutter/data/models/topic_db.dart';
import 'package:acl_flutter/domain/models/topic.dart';

class TopicMapper {
  static Topic fromDb(TopicDb db) {
    return Topic(
      id: db.id,
      name: db.name,
      description: db.description,
      startDate: db.startDate != null ? DateTime.parse(db.startDate!) : null,
      endDate: db.endDate != null ? DateTime.parse(db.endDate!) : null,
    );
  }

  static TopicDb fromDomain(Topic topic) {
    return TopicDb(
      id: topic.id,
      name: topic.name,
      description: topic.description,
      startDate: topic.startDate?.toIso8601String(),
      endDate: topic.endDate?.toIso8601String(),
    );
  }
}
