import 'dart:math';

import 'package:acl_flutter/app/dtos/anomaly_create_dto.dart';
import 'package:acl_flutter/app/dtos/anomaly_update_dto.dart';
import 'package:acl_flutter/data/database.dart';
import 'package:acl_flutter/data/models/anomaly_db.dart';
import 'package:acl_flutter/domain/enums/anomaly_enums.dart';
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
    final anomaliesDb = await db.anomalyRepo.getPagedAnomalies(
      lastId,
      pageSize,
    );
    return anomaliesDb.map(AnomalyMapper.fromDb).toList();
  }

  Future<Anomaly?> getAnomalyById(int id) async {
    final db = await AppDatabase.instance;
    final anomalyDb = await db.anomalyRepo.getAnomalyById(id);
    return anomalyDb != null ? AnomalyMapper.fromDb(anomalyDb) : null;
  }

  Future<Anomaly?> getAnomalyByCode(int code) async {
    final db = await AppDatabase.instance;
    final anomalyDb = await db.anomalyRepo.getAnomalyByCode(code);
    return anomalyDb != null ? AnomalyMapper.fromDb(anomalyDb) : null;
  }

  Future<List<Anomaly>> getAnomalyByName(String name) async {
    final db = await AppDatabase.instance;
    final anomaliesDb = await db.anomalyRepo.getAnomaliesByName('%$name%');
    return anomaliesDb.map(AnomalyMapper.fromDb).toList();
  }

  Future<List<Anomaly>> searchAnomalies(String query) async {
    final db = await AppDatabase.instance;
    final anomaliesDb = await db.anomalyRepo.searchAnomalies('%$query%');
    return anomaliesDb.map(AnomalyMapper.fromDb).toList();
  }

  Future<Anomaly?> createAnomaly(AnomalyCreateDto anomalyCreateDto) async {
    const int bottom = 100;
    const int top = 1000;
    const int range = top - bottom + 1;
    final db = await AppDatabase.instance;
    final random = Random();
    int code;
    int attempts = 0;
    do {
      if (attempts >= range) {
        throw StateError('No available codes in range $bottom–$top');
      }
      code = bottom + random.nextInt(range);
      attempts++;
    } while ((await db.anomalyRepo.getAnomalyByCode(code)) != null);
    final String nameSearch =
        "${anomalyCreateDto.type.name.toUpperCase()}${anomalyCreateDto.classification.index}_$code";
    final anomalyDb = AnomalyMapper.fromDomain(
      Anomaly(
        code: code,
        type: anomalyCreateDto.type,
        classification: anomalyCreateDto.classification,
        disruption: anomalyCreateDto.disruption,
        hostility: anomalyCreateDto.hostility,
        info: anomalyCreateDto.info,
        nameSearch: nameSearch,
        coordinates: anomalyCreateDto.coordinates,
        name: anomalyCreateDto.name,
        phone: anomalyCreateDto.phone,
        value: anomalyCreateDto.value,
      ),
    );
    final int id = await db.anomalyRepo.createAnomaly(anomalyDb);
    return AnomalyMapper.fromDb(
      AnomalyDb(
        id: id,
        code: anomalyDb.code,
        type: anomalyDb.type,
        classification: anomalyDb.classification,
        disruption: anomalyDb.disruption,
        hostility: anomalyDb.hostility,
        info: anomalyDb.info,
        nameSearch: anomalyDb.nameSearch,
        name: anomalyDb.name,
        phone: anomalyDb.phone,
        latitude: anomalyDb.latitude,
        longitude: anomalyDb.longitude,
        value: anomalyDb.value,
      ),
    );
  }

  Future<Anomaly?> updateAnomaly(
    int id,
    AnomalyUpdateDto anomalyUpdateDto,
  ) async {
    final db = await AppDatabase.instance;
    final existingDb = await db.anomalyRepo.getAnomalyById(id);
    if (existingDb == null) throw StateError("Anomaly not found");
    final type = anomalyUpdateDto.type ?? AnomalyType.values[existingDb.type];
    final classification =
        anomalyUpdateDto.classification ??
        AnomalyClass.values[existingDb.classification];
    final disruption =
        anomalyUpdateDto.disruption ??
        AnomalyDisruption.values[existingDb.disruption];
    final hostility =
        anomalyUpdateDto.hostility ??
        AnomalyHostility.values[existingDb.hostility];
    final info = anomalyUpdateDto.info ?? AnomalyInfo.values[existingDb.info];
    final nameSearch =
        "${type.name.toUpperCase()}${classification.index}_${existingDb.code}";

    final updatedDb = AnomalyMapper.fromDomain(
      Anomaly(
        id: id,
        code: existingDb.code,
        type: type,
        classification: classification,
        disruption: disruption,
        hostility: hostility,
        info: info,
        nameSearch: nameSearch,
        name: anomalyUpdateDto.name ?? existingDb.name,
        phone: anomalyUpdateDto.phone ?? existingDb.phone,
        coordinates:
            anomalyUpdateDto.coordinates ??
            (existingDb.latitude != null && existingDb.longitude != null
                ? Coordinates(
                    latitude: existingDb.latitude!,
                    longitude: existingDb.longitude!,
                  )
                : null),
        value: anomalyUpdateDto.value ?? existingDb.value,
      ),
    );
    await db.anomalyRepo.updateAnomaly(updatedDb);
    return AnomalyMapper.fromDb(updatedDb);
  }

  Future<void> deleteAnomaly(int id) async {
    final db = await AppDatabase.instance;
    await db.anomalyRepo.deleteAnomaly(id);
  }
}
