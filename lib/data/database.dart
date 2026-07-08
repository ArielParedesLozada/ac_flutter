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
    _instance ??= $FloorAppDatabase
        .databaseBuilder('app_database.db')
        .addCallback(Callback(onCreate: _createFts))
        .build();
    return _instance!;
  }

  static Future<void> _createFts(sqflite.Database db, int version) async {
    // Tabla FTS de contenido externo: los nombres de columna DEBEN coincidir
    // con los de anomaly_notes, porque FTS relee el texto original desde ahí.
    await db.execute('''
      CREATE VIRTUAL TABLE IF NOT EXISTS anomaly_notes_fts
      USING fts4(
        content="anomaly_notes",
        anomaly_name,
        content
      )
    ''');
    await db.execute('''
      CREATE TRIGGER anomaly_notes_ai AFTER INSERT ON anomaly_notes BEGIN
        INSERT INTO anomaly_notes_fts(docid, anomaly_name, content)
        VALUES (new.id, new.anomaly_name, new.content);
      END
    ''');
    // Con contenido externo el borrado del índice se hace con un DELETE normal
    // por docid, en un trigger BEFORE para que la fila aún exista y FTS pueda
    // leer los términos a eliminar.
    await db.execute('''
      CREATE TRIGGER anomaly_notes_ad BEFORE DELETE ON anomaly_notes BEGIN
        DELETE FROM anomaly_notes_fts WHERE docid = old.id;
      END
    ''');
    await db.execute('''
      CREATE TRIGGER anomaly_notes_bu BEFORE UPDATE ON anomaly_notes BEGIN
        DELETE FROM anomaly_notes_fts WHERE docid = old.id;
      END
    ''');
    await db.execute('''
      CREATE TRIGGER anomaly_notes_au AFTER UPDATE ON anomaly_notes BEGIN
        INSERT INTO anomaly_notes_fts(docid, anomaly_name, content)
        VALUES (new.id, new.anomaly_name, new.content);
      END
    ''');
  }
}
