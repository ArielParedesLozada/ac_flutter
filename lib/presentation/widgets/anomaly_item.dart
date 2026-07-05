import 'package:acl_flutter/domain/models/anomaly.dart';
import 'package:flutter/material.dart';

class AnomalyItem extends StatelessWidget {
  final Anomaly anomaly;
  const AnomalyItem({super.key, required this.anomaly});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.blue[50],
        child: ListTile(
          leading: const Icon(Icons.account_circle),
          title: Text(
            "${anomaly.type.name.toUpperCase()}${anomaly.type.index}_${anomaly.code}",
          ),
          trailing: const Icon(Icons.done),
          subtitle: Text(anomaly.name ?? ''),
          hoverColor: Colors.blue[50],
          onTap: () {},
        ),
      ),
    );
  }
}
