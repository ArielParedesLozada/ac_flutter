import 'package:acl_flutter/data/models/anomaly_db.dart';
import 'package:acl_flutter/domain/enums/anomaly_enums.dart';
import 'package:acl_flutter/domain/models/anomaly.dart';

class AnomalyMapper {
  static Anomaly fromDb(AnomalyDb anomaly) {
    return Anomaly(
      id: anomaly.id,
      code: anomaly.code,
      type: AnomalyType.values[anomaly.type],
      classification: AnomalyClass.values[anomaly.classification],
      disruption: AnomalyDisruption.values[anomaly.disruption],
      hostility: AnomalyHostility.values[anomaly.hostility],
      info: AnomalyInfo.values[anomaly.info],
      nameSearch: anomaly.nameSearch,
      name: anomaly.name,
      phone: anomaly.phone,
      coordinates: anomaly.latitude != null && anomaly.longitude != null
          ? Coordinates(
              latitude: anomaly.latitude!,
              longitude: anomaly.longitude!,
            )
          : null,
      value: anomaly.value,
    );
  }

  static AnomalyDb fromDomain(Anomaly anomaly) {
    return AnomalyDb(
      id: anomaly.id,
      code: anomaly.code,
      type: anomaly.type.index,
      classification: anomaly.classification.index,
      disruption: anomaly.disruption.index,
      hostility: anomaly.hostility.index,
      info: anomaly.info.index,
      nameSearch: anomaly.nameSearch,
      name: anomaly.name,
      phone: anomaly.phone,
      latitude: anomaly.coordinates?.latitude,
      longitude: anomaly.coordinates?.longitude,
      value: anomaly.value,
    );
  }
}
