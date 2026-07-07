import 'package:acl_flutter/domain/models/anomaly_note.dart';
import 'package:flutter/material.dart';

class AnomalyNoteItem extends StatelessWidget {
  final AnomalyNote anomalyNote;
  const AnomalyNoteItem({super.key, required this.anomalyNote});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
        tileColor: const Color.fromARGB(255, 202, 219, 255),
        leading: const Icon(Icons.info),
        title: Text(anomalyNote.content),
        subtitle: Text(anomalyNote.anomalyName),
      ),
    );
  }
}
