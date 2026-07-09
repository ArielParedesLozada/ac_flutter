import 'package:acl_flutter/data/models/topic_db.dart';
import 'package:floor/floor.dart';

@dao
abstract class TopicRepo {
  @Query('SELECT * FROM topics ORDER BY name')
  Future<List<TopicDb>> getAllTopics();

  @Query('SELECT * FROM topics WHERE id = :id')
  Future<TopicDb?> getTopicById(int id);

  @Query('SELECT * FROM topics WHERE name LIKE :query ORDER BY name')
  Future<List<TopicDb>> searchTopics(String query);

  @Insert(onConflict: OnConflictStrategy.abort)
  Future<int> createTopic(TopicDb topic);

  @Update(onConflict: OnConflictStrategy.abort)
  Future<int> updateTopic(TopicDb topic);

  @Query('DELETE FROM topics WHERE id = :id')
  Future<void> deleteTopic(int id);
}
