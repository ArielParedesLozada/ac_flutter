class TopicNote {
  final int? id;
  final int topicId;
  final String topicName;
  final String content;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? relatedEntityId;

  TopicNote({
    this.id,
    required this.topicId,
    required this.topicName,
    required this.content,
    this.startDate,
    this.endDate,
    this.relatedEntityId,
  });
}
