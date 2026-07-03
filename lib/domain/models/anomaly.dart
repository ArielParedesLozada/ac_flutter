import 'package:acl_flutter/domain/enums/anomaly_enums.dart';

class Anomaly {
  final int? id;
  final int code;
  final AnomalyType type;
  final AnomalyClass classification;
  final AnomalyDisruption disruption;
  final AnomalyHostility hostility;
  final AnomalyInfo info;
  final String? name;
  final String? phone;
  final Coordinates? coordinates;
  final double? value;

  Anomaly({
    this.id,
    required this.code,
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

class Coordinates {
  final double latitude;
  final double longitude;
  Coordinates({required this.latitude, required this.longitude});
}
