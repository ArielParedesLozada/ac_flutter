class TopicNoteUpdateDto {
  final String? content;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? relatedEntityId;

  TopicNoteUpdateDto({
    this.content,
    this.startDate,
    this.endDate,
    this.relatedEntityId,
  });
}
