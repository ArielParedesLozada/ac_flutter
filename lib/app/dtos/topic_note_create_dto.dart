class TopicNoteCreateDto {
  final int topicId;
  final String content;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? relatedEntityId;

  TopicNoteCreateDto({
    required this.topicId,
    required this.content,
    this.startDate,
    this.endDate,
    this.relatedEntityId,
  });
}
