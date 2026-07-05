import 'package:acl_flutter/domain/enums/anomaly_enums.dart';
import 'package:acl_flutter/domain/models/anomaly.dart';

class AnomalyCreateDto {
  final AnomalyType type;
  final AnomalyClass classification;
  final AnomalyDisruption disruption;
  final AnomalyHostility hostility;
  final AnomalyInfo info;
  final String? name;
  final String? phone;
  final Coordinates? coordinates;
  final double? value;

  AnomalyCreateDto({
    required this.type,
    required this.classification,
    required this.disruption,
    required this.hostility,
    required this.info,
    this.coordinates,
    this.name,
    this.phone,
    this.value,
  });
}
