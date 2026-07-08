import 'package:acl_flutter/app/anomaly_note_service.dart';
import 'package:acl_flutter/domain/models/anomaly_note.dart';
import 'package:flutter/material.dart';

class AnomalyNoteFull extends StatefulWidget {
  final AnomalyNote note;
  final VoidCallback onSaved;

  const AnomalyNoteFull({super.key, required this.note, required this.onSaved});

  static Future<void> show(
    BuildContext context,
    AnomalyNote note,
    VoidCallback onSaved,
  ) {
    return showDialog(
      context: context,
      builder: (_) => AnomalyNoteFull(note: note, onSaved: onSaved),
    );
  }

  @override
  State<AnomalyNoteFull> createState() => _AnomalyNoteFullState();
}

class _AnomalyNoteFullState extends State<AnomalyNoteFull> {
  final _service = AnomalyNoteService();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _contentController;

  String _fmtDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$d/$m/${dt.year} $h:$min';
  }

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await _service.updateNoteContent(widget.note, _contentController.text.trim());
    if (!mounted) return;
    Navigator.pop(context);
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    final note = widget.note;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _fmtDate(note.createdAt),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  note.updatedAt != null ? _fmtDate(note.updatedAt!) : '—',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Creado',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Colors.grey),
                ),
                Text(
                  'Actualizado',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              note.anomalyName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Contenido'),
                maxLines: 5,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Ingresa el contenido' : null,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
