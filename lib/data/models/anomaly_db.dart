import 'package:floor/floor.dart';

// Como se guarda la entidad en SQLite
@Entity(tableName: 'anomalies')
class AnomalyDb {
  @primaryKey
  final int? id;
  @ColumnInfo(name: 'code')
  final int code;
  @ColumnInfo(name: 'type')
  final int type;
  @ColumnInfo(name: 'classification')
  final int classification;
  @ColumnInfo(name: 'disruption')
  final int disruption;
  @ColumnInfo(name: 'hostility')
  final int hostility;
  @ColumnInfo(name: 'info')
  final int info;
  @ColumnInfo(name: 'name')
  final String? name;
  @ColumnInfo(name: 'phone')
  final String? phone;
  @ColumnInfo(name: 'latitude')
  final double? latitude;
  @ColumnInfo(name: 'longitude')
  final double? longitude;
  @ColumnInfo(name: 'value')
  final double? value;

  AnomalyDb({
    this.id,
    required this.code,
    required this.type,
    required this.classification,
    required this.disruption,
    required this.hostility,
    required this.info,
    this.latitude,
    this.longitude,
    this.name,
    this.phone,
    this.value,
  });
}
