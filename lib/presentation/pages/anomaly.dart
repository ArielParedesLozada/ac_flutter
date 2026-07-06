import 'package:acl_flutter/app/anomaly_service.dart';
import 'package:acl_flutter/app/dtos/anomaly_update_dto.dart';
import 'package:acl_flutter/domain/models/anomaly.dart';
import 'package:acl_flutter/presentation/widgets/anomaly_form.dart';
import 'package:flutter/material.dart';

class AnomalyPage extends StatefulWidget {
  final Anomaly anomaly;
  const AnomalyPage({super.key, required this.anomaly});

  @override
  State<AnomalyPage> createState() => _AnomalyPageState();
}

class _AnomalyPageState extends State<AnomalyPage> {
  final AnomalyService anomalyService = AnomalyService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Anomalía"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AnomalyForm(
          anomaly: widget.anomaly,
          onSubmit: (dto) async {
            await anomalyService.updateAnomaly(
              widget.anomaly.id!,
              AnomalyUpdateDto(
                type: dto.type,
                classification: dto.classification,
                disruption: dto.disruption,
                hostility: dto.hostility,
                info: dto.info,
                name: dto.name,
                phone: dto.phone,
                coordinates: dto.coordinates,
                value: dto.value,
              ),
            );
            if (context.mounted) Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
