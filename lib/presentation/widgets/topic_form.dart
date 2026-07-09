import 'package:acl_flutter/app/dtos/topic_create_dto.dart';
import 'package:acl_flutter/domain/models/topic.dart';
import 'package:flutter/material.dart';

class TopicForm extends StatefulWidget {
  final Topic? topic;
  final void Function(TopicCreateDto) onSubmit;

  const TopicForm({super.key, this.topic, required this.onSubmit});

  @override
  State<TopicForm> createState() => _TopicFormState();
}

class _TopicFormState extends State<TopicForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final t = widget.topic;
    _nameController = TextEditingController(text: t?.name ?? '');
    _descriptionController = TextEditingController(text: t?.description ?? '');
    _startDate = t?.startDate;
    _endDate = t?.endDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }

  Future<void> _pickDate({
    required DateTime? current,
    required void Function(DateTime?) onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => onPicked(picked));
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required void Function(DateTime?) onPicked,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: InkWell(
        onTap: () => _pickDate(current: date, onPicked: onPicked),
        borderRadius: BorderRadius.circular(4),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: date != null
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () => setState(() => onPicked(null)),
                  )
                : const Icon(Icons.calendar_today, size: 18),
          ),
          child: Text(
            date != null ? _formatDate(date) : '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      TopicCreateDto(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        startDate: _startDate,
        endDate: _endDate,
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
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nombre'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'El nombre es requerido' : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Descripción'),
            maxLines: 3,
            minLines: 1,
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
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _submit, child: const Text('Guardar')),
        ],
      ),
    );
  }
}
