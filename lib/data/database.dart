import 'dart:async';
import 'package:acl_flutter/data/repos/anomaly_note_repo.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:acl_flutter/data/models/anomaly_db.dart';
import 'package:acl_flutter/data/models/anomaly_note_db.dart';
import 'package:acl_flutter/data/repos/anomaly_repo.dart';

part 'database.g.dart';

@Database(version: 1, entities: [AnomalyDb, AnomalyNoteDb])
abstract class AppDatabase extends FloorDatabase {
  AnomalyRepo get anomalyRepo;
  AnomalyNoteRepo get anomalyNoteRepo;

  static Future<AppDatabase>? _instance;

  static Future<AppDatabase> get instance {
    _instance ??= $FloorAppDatabase.databaseBuilder('app_database.db').build();
    return _instance!;
  }
}
