import 'package:acl_flutter/domain/models/anomaly.dart';
import 'package:flutter/material.dart';

class AnomalyItem extends StatelessWidget {
  final Anomaly anomaly;
  const AnomalyItem({super.key, required this.anomaly});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        color: Colors.blue[50],
        child: ListTile(
          leading: const Icon(Icons.account_circle),
          title: Text(anomaly.nameSearch),
          trailing: const Icon(Icons.keyboard_arrow_down),
          subtitle: Text(anomaly.name ?? ''),
          onTap: () {},
        ),
      ),
    );
  }
}
