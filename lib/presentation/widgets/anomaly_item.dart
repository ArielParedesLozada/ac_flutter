import 'package:acl_flutter/domain/models/anomaly.dart';
import 'package:acl_flutter/presentation/pages/anomaly.dart';
import 'package:flutter/material.dart';

class AnomalyItem extends StatelessWidget {
  final Anomaly anomaly;
  final VoidCallback? onReturn;
  const AnomalyItem({super.key, required this.anomaly, this.onReturn});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: const Color.fromARGB(255, 199, 230, 255),
      leading: const Icon(Icons.account_circle),
      title: Text(anomaly.nameSearch),
      trailing: const Icon(Icons.keyboard_arrow_down),
      subtitle: Text(anomaly.name ?? ''),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AnomalyPage(anomaly: anomaly)),
        ).then((_) => onReturn?.call());
      },
    );
  }
}
