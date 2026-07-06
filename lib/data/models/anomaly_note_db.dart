import 'package:floor/floor.dart';
import 'package:acl_flutter/data/models/anomaly_db.dart';

@Entity(
  tableName: 'anomaly_notes',
  foreignKeys: [
    ForeignKey(
      childColumns: ['anomaly_id'],
      parentColumns: ['id'],
      entity: AnomalyDb,
    ),
  ],
)
class AnomalyNoteDb {
  @primaryKey
  final int? id;
  @ColumnInfo(name: 'anomaly_id')
  final int anomalyId;
  @ColumnInfo(name: 'anomaly_name')
  final String anomalyName;
  @ColumnInfo(name: 'content')
  final String content;
  @ColumnInfo(name: 'created_at')
  final String createdAt;
  @ColumnInfo(name: 'updated_at')
  final String? updatedAt;

  AnomalyNoteDb({
    this.id,
    required this.anomalyId,
    required this.anomalyName,
    required this.content,
    required this.createdAt,
    this.updatedAt,
  });
}
