// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AnomalyRepo? _anomalyRepoInstance;

  AnomalyNoteRepo? _anomalyNoteRepoInstance;

  TopicRepo? _topicRepoInstance;

  TopicNoteRepo? _topicNoteRepoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `anomalies` (`id` INTEGER, `code` INTEGER NOT NULL, `type` INTEGER NOT NULL, `classification` INTEGER NOT NULL, `disruption` INTEGER NOT NULL, `hostility` INTEGER NOT NULL, `info` INTEGER NOT NULL, `nameSearch` TEXT NOT NULL, `name` TEXT, `phone` TEXT, `contact_id` TEXT, `latitude` REAL, `longitude` REAL, `value` REAL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `anomaly_notes` (`id` INTEGER, `anomaly_id` INTEGER NOT NULL, `anomaly_name` TEXT NOT NULL, `content` TEXT NOT NULL, `created_at` TEXT NOT NULL, `updated_at` TEXT, FOREIGN KEY (`anomaly_id`) REFERENCES `anomalies` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `topics` (`id` INTEGER, `name` TEXT NOT NULL, `description` TEXT, `start_date` TEXT, `end_date` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `topic_notes` (`id` INTEGER, `topic_id` INTEGER NOT NULL, `topic_name` TEXT NOT NULL, `content` TEXT NOT NULL, `start_date` TEXT, `end_date` TEXT, `related_entity_id` INTEGER, FOREIGN KEY (`topic_id`) REFERENCES `topics` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE UNIQUE INDEX `index_anomalies_code` ON `anomalies` (`code`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AnomalyRepo get anomalyRepo {
    return _anomalyRepoInstance ??= _$AnomalyRepo(database, changeListener);
  }

  @override
  AnomalyNoteRepo get anomalyNoteRepo {
    return _anomalyNoteRepoInstance ??=
        _$AnomalyNoteRepo(database, changeListener);
  }

  @override
  TopicRepo get topicRepo {
    return _topicRepoInstance ??= _$TopicRepo(database, changeListener);
  }

  @override
  TopicNoteRepo get topicNoteRepo {
    return _topicNoteRepoInstance ??= _$TopicNoteRepo(database, changeListener);
  }
}

class _$AnomalyRepo extends AnomalyRepo {
  _$AnomalyRepo(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _anomalyDbInsertionAdapter = InsertionAdapter(
            database,
            'anomalies',
            (AnomalyDb item) => <String, Object?>{
                  'id': item.id,
                  'code': item.code,
                  'type': item.type,
                  'classification': item.classification,
                  'disruption': item.disruption,
                  'hostility': item.hostility,
                  'info': item.info,
                  'nameSearch': item.nameSearch,
                  'name': item.name,
                  'phone': item.phone,
                  'contact_id': item.contactId,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'value': item.value
                }),
        _anomalyDbUpdateAdapter = UpdateAdapter(
            database,
            'anomalies',
            ['id'],
            (AnomalyDb item) => <String, Object?>{
                  'id': item.id,
                  'code': item.code,
                  'type': item.type,
                  'classification': item.classification,
                  'disruption': item.disruption,
                  'hostility': item.hostility,
                  'info': item.info,
                  'nameSearch': item.nameSearch,
                  'name': item.name,
                  'phone': item.phone,
                  'contact_id': item.contactId,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'value': item.value
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AnomalyDb> _anomalyDbInsertionAdapter;

  final UpdateAdapter<AnomalyDb> _anomalyDbUpdateAdapter;

  @override
  Future<List<AnomalyDb>> getAllAnomalies() async {
    return _queryAdapter.queryList('SELECT * FROM anomalies',
        mapper: (Map<String, Object?> row) => AnomalyDb(
            id: row['id'] as int?,
            code: row['code'] as int,
            type: row['type'] as int,
            classification: row['classification'] as int,
            disruption: row['disruption'] as int,
            hostility: row['hostility'] as int,
            info: row['info'] as int,
            nameSearch: row['nameSearch'] as String,
            latitude: row['latitude'] as double?,
            longitude: row['longitude'] as double?,
            name: row['name'] as String?,
            phone: row['phone'] as String?,
            contactId: row['contact_id'] as String?,
            value: row['value'] as double?));
  }

  @override
  Future<List<AnomalyDb>> getPagedAnomalies(
    int lastId,
    int limit,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM anomalies WHERE id > ?1 ORDER BY id LIMIT ?2',
        mapper: (Map<String, Object?> row) => AnomalyDb(
            id: row['id'] as int?,
            code: row['code'] as int,
            type: row['type'] as int,
            classification: row['classification'] as int,
            disruption: row['disruption'] as int,
            hostility: row['hostility'] as int,
            info: row['info'] as int,
            nameSearch: row['nameSearch'] as String,
            latitude: row['latitude'] as double?,
            longitude: row['longitude'] as double?,
            name: row['name'] as String?,
            phone: row['phone'] as String?,
            contactId: row['contact_id'] as String?,
            value: row['value'] as double?),
        arguments: [lastId, limit]);
  }

  @override
  Future<AnomalyDb?> getAnomalyById(int id) async {
    return _queryAdapter.query('SELECT * FROM anomalies WHERE id = ?1',
        mapper: (Map<String, Object?> row) => AnomalyDb(
            id: row['id'] as int?,
            code: row['code'] as int,
            type: row['type'] as int,
            classification: row['classification'] as int,
            disruption: row['disruption'] as int,
            hostility: row['hostility'] as int,
            info: row['info'] as int,
            nameSearch: row['nameSearch'] as String,
            latitude: row['latitude'] as double?,
            longitude: row['longitude'] as double?,
            name: row['name'] as String?,
            phone: row['phone'] as String?,
            contactId: row['contact_id'] as String?,
            value: row['value'] as double?),
        arguments: [id]);
  }

  @override
  Future<AnomalyDb?> getAnomalyByCode(int code) async {
    return _queryAdapter.query('SELECT * FROM anomalies WHERE code = ?1',
        mapper: (Map<String, Object?> row) => AnomalyDb(
            id: row['id'] as int?,
            code: row['code'] as int,
            type: row['type'] as int,
            classification: row['classification'] as int,
            disruption: row['disruption'] as int,
            hostility: row['hostility'] as int,
            info: row['info'] as int,
            nameSearch: row['nameSearch'] as String,
            latitude: row['latitude'] as double?,
            longitude: row['longitude'] as double?,
            name: row['name'] as String?,
            phone: row['phone'] as String?,
            contactId: row['contact_id'] as String?,
            value: row['value'] as double?),
        arguments: [code]);
  }

  @override
  Future<List<AnomalyDb>> getAnomaliesByName(String name) async {
    return _queryAdapter.queryList('SELECT * FROM anomalies WHERE name LIKE ?1',
        mapper: (Map<String, Object?> row) => AnomalyDb(
            id: row['id'] as int?,
            code: row['code'] as int,
            type: row['type'] as int,
            classification: row['classification'] as int,
            disruption: row['disruption'] as int,
            hostility: row['hostility'] as int,
            info: row['info'] as int,
            nameSearch: row['nameSearch'] as String,
            latitude: row['latitude'] as double?,
            longitude: row['longitude'] as double?,
            name: row['name'] as String?,
            phone: row['phone'] as String?,
            contactId: row['contact_id'] as String?,
            value: row['value'] as double?),
        arguments: [name]);
  }

  @override
  Future<List<AnomalyDb>> searchAnomalies(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM anomalies WHERE name LIKE ?1 OR code LIKE ?1 OR nameSearch LIKE ?1',
        mapper: (Map<String, Object?> row) => AnomalyDb(id: row['id'] as int?, code: row['code'] as int, type: row['type'] as int, classification: row['classification'] as int, disruption: row['disruption'] as int, hostility: row['hostility'] as int, info: row['info'] as int, nameSearch: row['nameSearch'] as String, latitude: row['latitude'] as double?, longitude: row['longitude'] as double?, name: row['name'] as String?, phone: row['phone'] as String?, contactId: row['contact_id'] as String?, value: row['value'] as double?),
        arguments: [query]);
  }

  @override
  Future<void> deleteAnomaly(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM anomalies WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<int> createAnomaly(AnomalyDb anomaly) {
    return _anomalyDbInsertionAdapter.insertAndReturnId(
        anomaly, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateAnomaly(AnomalyDb anomaly) {
    return _anomalyDbUpdateAdapter.updateAndReturnChangedRows(
        anomaly, OnConflictStrategy.abort);
  }
}

class _$AnomalyNoteRepo extends AnomalyNoteRepo {
  _$AnomalyNoteRepo(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _anomalyNoteDbInsertionAdapter = InsertionAdapter(
            database,
            'anomaly_notes',
            (AnomalyNoteDb item) => <String, Object?>{
                  'id': item.id,
                  'anomaly_id': item.anomalyId,
                  'anomaly_name': item.anomalyName,
                  'content': item.content,
                  'created_at': item.createdAt,
                  'updated_at': item.updatedAt
                }),
        _anomalyNoteDbUpdateAdapter = UpdateAdapter(
            database,
            'anomaly_notes',
            ['id'],
            (AnomalyNoteDb item) => <String, Object?>{
                  'id': item.id,
                  'anomaly_id': item.anomalyId,
                  'anomaly_name': item.anomalyName,
                  'content': item.content,
                  'created_at': item.createdAt,
                  'updated_at': item.updatedAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AnomalyNoteDb> _anomalyNoteDbInsertionAdapter;

  final UpdateAdapter<AnomalyNoteDb> _anomalyNoteDbUpdateAdapter;

  @override
  Future<List<AnomalyNoteDb>> getAllAnomalyNotes() async {
    return _queryAdapter.queryList('SELECT * FROM anomaly_notes',
        mapper: (Map<String, Object?> row) => AnomalyNoteDb(
            id: row['id'] as int?,
            anomalyId: row['anomaly_id'] as int,
            anomalyName: row['anomaly_name'] as String,
            content: row['content'] as String,
            createdAt: row['created_at'] as String,
            updatedAt: row['updated_at'] as String?));
  }

  @override
  Future<List<AnomalyNoteDb>> searchNotes(String query) async {
    return _queryAdapter.queryList(
        'SELECT an.* FROM anomaly_notes an INNER JOIN anomaly_notes_fts fts ON an.id = fts.docid WHERE anomaly_notes_fts MATCH ?1',
        mapper: (Map<String, Object?> row) => AnomalyNoteDb(id: row['id'] as int?, anomalyId: row['anomaly_id'] as int, anomalyName: row['anomaly_name'] as String, content: row['content'] as String, createdAt: row['created_at'] as String, updatedAt: row['updated_at'] as String?),
        arguments: [query]);
  }

  @override
  Future<List<AnomalyNoteDb>> anomaliesByAnomalyId(int anomalyId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM anomaly_notes WHERE anomaly_id = ?1 ORDER BY created_at',
        mapper: (Map<String, Object?> row) => AnomalyNoteDb(
            id: row['id'] as int?,
            anomalyId: row['anomaly_id'] as int,
            anomalyName: row['anomaly_name'] as String,
            content: row['content'] as String,
            createdAt: row['created_at'] as String,
            updatedAt: row['updated_at'] as String?),
        arguments: [anomalyId]);
  }

  @override
  Future<void> deleteNote(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM anomaly_notes WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<int> createNote(AnomalyNoteDb anomalyNote) {
    return _anomalyNoteDbInsertionAdapter.insertAndReturnId(
        anomalyNote, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateNote(AnomalyNoteDb anomalyNote) {
    return _anomalyNoteDbUpdateAdapter.updateAndReturnChangedRows(
        anomalyNote, OnConflictStrategy.abort);
  }
}

class _$TopicRepo extends TopicRepo {
  _$TopicRepo(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _topicDbInsertionAdapter = InsertionAdapter(
            database,
            'topics',
            (TopicDb item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'start_date': item.startDate,
                  'end_date': item.endDate
                }),
        _topicDbUpdateAdapter = UpdateAdapter(
            database,
            'topics',
            ['id'],
            (TopicDb item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'start_date': item.startDate,
                  'end_date': item.endDate
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TopicDb> _topicDbInsertionAdapter;

  final UpdateAdapter<TopicDb> _topicDbUpdateAdapter;

  @override
  Future<List<TopicDb>> getAllTopics() async {
    return _queryAdapter.queryList('SELECT * FROM topics ORDER BY name',
        mapper: (Map<String, Object?> row) => TopicDb(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            startDate: row['start_date'] as String?,
            endDate: row['end_date'] as String?));
  }

  @override
  Future<TopicDb?> getTopicById(int id) async {
    return _queryAdapter.query('SELECT * FROM topics WHERE id = ?1',
        mapper: (Map<String, Object?> row) => TopicDb(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            startDate: row['start_date'] as String?,
            endDate: row['end_date'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<TopicDb>> searchTopics(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM topics WHERE name LIKE ?1 ORDER BY name',
        mapper: (Map<String, Object?> row) => TopicDb(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String?,
            startDate: row['start_date'] as String?,
            endDate: row['end_date'] as String?),
        arguments: [query]);
  }

  @override
  Future<void> deleteTopic(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM topics WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<int> createTopic(TopicDb topic) {
    return _topicDbInsertionAdapter.insertAndReturnId(
        topic, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateTopic(TopicDb topic) {
    return _topicDbUpdateAdapter.updateAndReturnChangedRows(
        topic, OnConflictStrategy.abort);
  }
}

class _$TopicNoteRepo extends TopicNoteRepo {
  _$TopicNoteRepo(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _topicNoteDbInsertionAdapter = InsertionAdapter(
            database,
            'topic_notes',
            (TopicNoteDb item) => <String, Object?>{
                  'id': item.id,
                  'topic_id': item.topicId,
                  'topic_name': item.topicName,
                  'content': item.content,
                  'start_date': item.startDate,
                  'end_date': item.endDate,
                  'related_entity_id': item.relatedEntityId
                }),
        _topicNoteDbUpdateAdapter = UpdateAdapter(
            database,
            'topic_notes',
            ['id'],
            (TopicNoteDb item) => <String, Object?>{
                  'id': item.id,
                  'topic_id': item.topicId,
                  'topic_name': item.topicName,
                  'content': item.content,
                  'start_date': item.startDate,
                  'end_date': item.endDate,
                  'related_entity_id': item.relatedEntityId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TopicNoteDb> _topicNoteDbInsertionAdapter;

  final UpdateAdapter<TopicNoteDb> _topicNoteDbUpdateAdapter;

  @override
  Future<List<TopicNoteDb>> getAllTopicNotes() async {
    return _queryAdapter.queryList('SELECT * FROM topic_notes',
        mapper: (Map<String, Object?> row) => TopicNoteDb(
            id: row['id'] as int?,
            topicId: row['topic_id'] as int,
            topicName: row['topic_name'] as String,
            content: row['content'] as String,
            startDate: row['start_date'] as String?,
            endDate: row['end_date'] as String?,
            relatedEntityId: row['related_entity_id'] as int?));
  }

  @override
  Future<List<TopicNoteDb>> getNotesByTopicId(int topicId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM topic_notes WHERE topic_id = ?1 ORDER BY start_date',
        mapper: (Map<String, Object?> row) => TopicNoteDb(
            id: row['id'] as int?,
            topicId: row['topic_id'] as int,
            topicName: row['topic_name'] as String,
            content: row['content'] as String,
            startDate: row['start_date'] as String?,
            endDate: row['end_date'] as String?,
            relatedEntityId: row['related_entity_id'] as int?),
        arguments: [topicId]);
  }

  @override
  Future<List<TopicNoteDb>> searchNotes(String query) async {
    return _queryAdapter.queryList(
        'SELECT tn.* FROM topic_notes tn INNER JOIN topic_notes_fts fts ON tn.id = fts.docid WHERE topic_notes_fts MATCH ?1 ORDER BY CASE WHEN tn.end_date IS NULL THEN 1 ELSE 0 END, tn.end_date ASC',
        mapper: (Map<String, Object?> row) => TopicNoteDb(id: row['id'] as int?, topicId: row['topic_id'] as int, topicName: row['topic_name'] as String, content: row['content'] as String, startDate: row['start_date'] as String?, endDate: row['end_date'] as String?, relatedEntityId: row['related_entity_id'] as int?),
        arguments: [query]);
  }

  @override
  Future<void> deleteNote(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM topic_notes WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<int> createNote(TopicNoteDb note) {
    return _topicNoteDbInsertionAdapter.insertAndReturnId(
        note, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateNote(TopicNoteDb note) {
    return _topicNoteDbUpdateAdapter.updateAndReturnChangedRows(
        note, OnConflictStrategy.abort);
  }
}
