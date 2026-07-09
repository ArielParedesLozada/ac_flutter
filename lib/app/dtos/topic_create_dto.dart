class TopicCreateDto {
  final String name;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;

  TopicCreateDto({
    required this.name,
    this.description,
    this.startDate,
    this.endDate,
  });
}
