class AnomalyNote {
  final int? id;
  final int anomalyId;
  final String anomalyName;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;

  AnomalyNote({
    this.id,
    required this.anomalyId,
    required this.anomalyName,
    required this.content,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
