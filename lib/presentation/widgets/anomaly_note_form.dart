import 'package:acl_flutter/app/dtos/anomaly_note_create_dto.dart';
import 'package:acl_flutter/domain/models/anomaly.dart';
import 'package:acl_flutter/domain/models/anomaly_note.dart';
import 'package:acl_flutter/presentation/widgets/anomaly_search_field.dart';
import 'package:flutter/material.dart';

class AnomalyNoteForm extends StatefulWidget {
  final AnomalyNote? anomalyNote;
  final Anomaly? initialAnomaly;
  final void Function(AnomalyNoteCreateDto) onSubmit;

  const AnomalyNoteForm({
    super.key,
    this.anomalyNote,
    this.initialAnomaly,
    required this.onSubmit,
  });

  @override
  State<AnomalyNoteForm> createState() => _AnomalyNoteFormState();
}

class _AnomalyNoteFormState extends State<AnomalyNoteForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _contentController;
  Anomaly? _selectedAnomaly;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.anomalyNote?.content ?? '',
    );
    _selectedAnomaly = widget.initialAnomaly;
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      AnomalyNoteCreateDto(
        anomalyId: _selectedAnomaly!.id!,
        content: _contentController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnomalySearchField(
            initialValue: _selectedAnomaly,
            onSelected: (anomaly) => setState(() => _selectedAnomaly = anomaly),
            validator: (a) => a == null ? 'Selecciona una anomalía' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _contentController,
            decoration: const InputDecoration(
              labelText: 'Contenido de la nota',
            ),
            maxLines: 4,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Ingresa el contenido' : null,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              child: const Text('Guardar'),
            ),
          ),
        ],
      ),
    );
  }
}
