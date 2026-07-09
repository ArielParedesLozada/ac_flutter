class Topic {
  final int? id;
  final String name;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;

  Topic({
    this.id,
    required this.name,
    this.description,
    this.startDate,
    this.endDate,
  });
}
