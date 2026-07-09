import 'package:acl_flutter/app/topic_service.dart';
import 'package:acl_flutter/domain/models/topic.dart';
import 'package:flutter/material.dart';

class TopicSearchField extends StatefulWidget {
  final Topic? initialValue;
  final void Function(Topic) onSelected;
  final String? Function(Topic?)? validator;

  const TopicSearchField({
    super.key,
    this.initialValue,
    required this.onSelected,
    this.validator,
  });

  @override
  State<TopicSearchField> createState() => _TopicSearchFieldState();
}

class _TopicSearchFieldState extends State<TopicSearchField> {
  final TopicService _service = TopicService();
  final _fieldKey = GlobalKey<FormFieldState<Topic>>();
  Topic? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  Future<void> _openPicker() async {
    final result = await showDialog<Topic>(
      context: context,
      builder: (_) => _TopicPickerDialog(service: _service),
    );
    if (result != null) {
      setState(() => _selected = result);
      _fieldKey.currentState?.didChange(result);
      widget.onSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<Topic>(
      key: _fieldKey,
      initialValue: _selected,
      validator: widget.validator != null
          ? (_) => widget.validator!(_selected)
          : null,
      builder: (state) => InkWell(
        onTap: _openPicker,
        borderRadius: BorderRadius.circular(4),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Tema',
            errorText: state.errorText,
            suffixIcon: const Icon(Icons.search),
          ),
          child: Text(
            _selected?.name ?? 'Selecciona un tema',
            style: TextStyle(
              color: _selected == null ? Theme.of(context).hintColor : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _TopicPickerDialog extends StatefulWidget {
  final TopicService service;
  const _TopicPickerDialog({required this.service});

  @override
  State<_TopicPickerDialog> createState() => _TopicPickerDialogState();
}

class _TopicPickerDialogState extends State<_TopicPickerDialog> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Topic>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.service.getAllTopics();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    setState(() {
      _future = query.isEmpty
          ? widget.service.getAllTopics()
          : widget.service.searchTopics(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Buscar por nombre...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onQueryChanged,
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: FutureBuilder<List<Topic>>(
                future: _future,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    );
                  }
                  final items = snapshot.data!;
                  if (items.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('Sin resultados'),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final t = items[index];
                      return ListTile(
                        title: Text(t.name),
                        subtitle:
                            t.description != null ? Text(t.description!) : null,
                        onTap: () => Navigator.pop(context, t),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
