import 'package:acl_flutter/app/dtos/topic_note_create_dto.dart';
import 'package:acl_flutter/domain/models/anomaly.dart';
import 'package:acl_flutter/domain/models/topic.dart';
import 'package:acl_flutter/domain/models/topic_note.dart';
import 'package:acl_flutter/presentation/widgets/anomaly_search_field.dart';
import 'package:acl_flutter/presentation/widgets/topic_search_field.dart';
import 'package:flutter/material.dart';

class TopicNoteForm extends StatefulWidget {
  final TopicNote? topicNote;
  final Topic? initialTopic;
  final void Function(TopicNoteCreateDto) onSubmit;

  const TopicNoteForm({
    super.key,
    this.topicNote,
    this.initialTopic,
    required this.onSubmit,
  });

  @override
  State<TopicNoteForm> createState() => _TopicNoteFormState();
}

class _TopicNoteFormState extends State<TopicNoteForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _contentController;
  Topic? _selectedTopic;
  Anomaly? _selectedAnomaly;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.topicNote?.content ?? '',
    );
    _selectedTopic = widget.initialTopic;
    _startDate = widget.topicNote?.startDate;
    _endDate = widget.topicNote?.endDate;
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date, {bool withTime = false}) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final base = '$d/$m/${date.year}';
    if (!withTime) return base;
    final h = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    return '$base $h:$min';
  }

  Future<void> _pickDate({
    required DateTime? current,
    required void Function(DateTime?) onPicked,
    bool withTime = false,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    if (!withTime) {
      setState(() => onPicked(picked));
      return;
    }
    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: current != null
          ? TimeOfDay(hour: current.hour, minute: current.minute)
          : TimeOfDay.now(),
    );
    if (time == null) return;
    setState(() => onPicked(
          DateTime(picked.year, picked.month, picked.day, time.hour, time.minute),
        ));
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required void Function(DateTime?) onPicked,
    bool withTime = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: InkWell(
        onTap: () => _pickDate(current: date, onPicked: onPicked, withTime: withTime),
        borderRadius: BorderRadius.circular(4),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: date != null
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () => setState(() => onPicked(null)),
                  )
                : Icon(withTime ? Icons.access_time : Icons.calendar_today, size: 18),
          ),
          child: Text(
            date != null ? _formatDate(date, withTime: withTime) : '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      TopicNoteCreateDto(
        topicId: _selectedTopic!.id!,
        content: _contentController.text.trim(),
        startDate: _startDate,
        endDate: _endDate,
        relatedEntityId: _selectedAnomaly?.id,
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
          TopicSearchField(
            initialValue: _selectedTopic,
            onSelected: (topic) => setState(() => _selectedTopic = topic),
            validator: (t) => t == null ? 'Selecciona un tema' : null,
          ),
          const SizedBox(height: 12),
          AnomalySearchField(
            initialValue: _selectedAnomaly,
            onSelected: (anomaly) =>
                setState(() => _selectedAnomaly = anomaly),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _contentController,
            decoration: const InputDecoration(labelText: 'Contenido'),
            maxLines: 4,
            minLines: 2,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Ingresa el contenido' : null,
          ),
          _buildDateField(
            label: 'Fecha de inicio',
            date: _startDate,
            onPicked: (d) => _startDate = d,
          ),
          _buildDateField(
            label: 'Fecha de fin',
            date: _endDate,
            onPicked: (d) => _endDate = d,
            withTime: true,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: _submit, child: const Text('Guardar')),
          ),
        ],
      ),
    );
  }
}
