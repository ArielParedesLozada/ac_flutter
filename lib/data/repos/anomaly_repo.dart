import 'package:acl_flutter/data/models/anomaly_db.dart';
import 'package:floor/floor.dart';

@dao
abstract class AnomalyRepo {
  @Query('SELECT * FROM anomalies')
  Future<List<AnomalyDb>> getAllAnomalies();

  @Query('SELECT * FROM anomalies WHERE id > :lastId ORDER BY id LIMIT :limit')
  Future<List<AnomalyDb>> getPagedAnomalies(int lastId, int limit);

  @Query('SELECT * FROM anomalies WHERE id = :id')
  Future<AnomalyDb?> getAnomalyById(int id);

  @Query('SELECT * FROM anomalies WHERE code = :code')
  Future<AnomalyDb?> getAnomalyByCode(int code);

  @Query('SELECT * FROM anomalies WHERE name LIKE :name')
  Future<List<AnomalyDb>> getAnomaliesByName(String name);

  @Query('SELECT * FROM anomalies WHERE name LIKE :query OR code LIKE :query OR nameSearch LIKE :query')
  Future<List<AnomalyDb>> searchAnomalies(String query);

  @Insert(onConflict: OnConflictStrategy.abort)
  Future<int> createAnomaly(AnomalyDb anomaly);
}
