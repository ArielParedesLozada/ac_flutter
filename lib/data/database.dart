import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:acl_flutter/data/models/anomaly_db.dart';
import 'package:acl_flutter/data/repos/anomaly_repo.dart';

part 'database.g.dart';

@Database(version: 1, entities: [AnomalyDb])
abstract class AppDatabase extends FloorDatabase {
  AnomalyRepo get anomalyRepo;

  static Future<AppDatabase> init() async {
    return await $FloorAppDatabase
        .databaseBuilder('app_database.db') // Debe estar en un .db en la raiz del proyecto 
        .build();
  }
}