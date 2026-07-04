import 'package:acl_flutter/data/database.dart';
import 'package:acl_flutter/domain/models/anomaly.dart';
import 'package:acl_flutter/infrastructure/mapper/anomaly_mapper.dart';

class AnomalyService {
  Future<List<Anomaly>> getAnomalies() async {
    final db = await AppDatabase.instance;
    final anomaliesDb = await db.anomalyRepo.getAllAnomalies();
    return anomaliesDb.map(AnomalyMapper.fromDb).toList();
  }

  Future<List<Anomaly>> getPagedAnomalies(int lastId, int pageSize) async {
    final db = await AppDatabase.instance;
    final anomaliesDb = await db.anomalyRepo.getPagedAnomalies(lastId, pageSize);
    return anomaliesDb.map(AnomalyMapper.fromDb).toList();
  }
}
