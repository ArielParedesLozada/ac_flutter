import 'package:floor/floor.dart';

@Entity(tableName: 'topics')
class TopicDb {
  @primaryKey
  final int? id;
  @ColumnInfo(name: 'name')
  final String name;
  @ColumnInfo(name: 'description')
  final String? description;
  @ColumnInfo(name: 'start_date')
  final String? startDate;
  @ColumnInfo(name: 'end_date')
  final String? endDate;

  TopicDb({
    this.id,
    required this.name,
    this.description,
    this.startDate,
    this.endDate,
  });
}
