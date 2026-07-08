import 'package:acl_flutter/domain/models/anomaly_note.dart';
import 'package:flutter/widgets.dart';

class AnomalyNoteForm extends StatefulWidget {
  final AnomalyNote note;
  const AnomalyNoteForm({super.key, required this.note});

  @override
  State<AnomalyNoteForm> createState() => _AnomalyNoteFormState();
}

class _AnomalyNoteFormState extends State<AnomalyNoteForm> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
