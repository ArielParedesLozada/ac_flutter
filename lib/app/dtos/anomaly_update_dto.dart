import 'package:acl_flutter/domain/enums/anomaly_enums.dart';
import 'package:acl_flutter/domain/models/anomaly.dart';

class AnomalyUpdateDto {
  final AnomalyType? type;
  final AnomalyClass? classification;
  final AnomalyDisruption? disruption;
  final AnomalyHostility? hostility;
  final AnomalyInfo? info;
  final String? name;
  final String? phone;
  final Coordinates? coordinates;
  final double? value;

  AnomalyUpdateDto({
    this.type,
    this.classification,
    this.disruption,
    this.hostility,
    this.info,
    this.coordinates,
    this.name,
    this.phone,
    this.value,
  });
}
