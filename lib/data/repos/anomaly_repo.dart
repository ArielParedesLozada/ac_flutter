import 'package:acl_flutter/data/models/anomaly_db.dart';
import 'package:floor/floor.dart';

@dao
abstract class AnomalyRepo {
  @Query('SELECT * FROM anomalies')
  Future<List<AnomalyDb>> getAllAnomalies();
  
  @Query('SELECT * FROM anomalies WHERE id > :lastId ORDER BY id LIMIT :limit')
  Future<List<AnomalyDb>> getPagedAnomalies(int lastId, int limit);
}