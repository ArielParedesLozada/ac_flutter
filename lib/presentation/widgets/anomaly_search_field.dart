import 'package:acl_flutter/app/anomaly_service.dart';
import 'package:acl_flutter/domain/models/anomaly.dart';
import 'package:flutter/material.dart';

class AnomalySearchField extends StatefulWidget {
  final Anomaly? initialValue;
  final void Function(Anomaly) onSelected;
  final String? Function(Anomaly?)? validator;

  const AnomalySearchField({
    super.key,
    this.initialValue,
    required this.onSelected,
    this.validator,
  });

  @override
  State<AnomalySearchField> createState() => _AnomalySearchFieldState();
}

class _AnomalySearchFieldState extends State<AnomalySearchField> {
  final AnomalyService _service = AnomalyService();
  final _fieldKey = GlobalKey<FormFieldState<Anomaly>>();
  Anomaly? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  Future<void> _openPicker() async {
    final result = await showDialog<Anomaly>(
      context: context,
      builder: (_) => _AnomalyPickerDialog(service: _service),
    );
    if (result != null) {
      setState(() => _selected = result);
      _fieldKey.currentState?.didChange(result);
      widget.onSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<Anomaly>(
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
            labelText: 'Anomalía',
            errorText: state.errorText,
            suffixIcon: const Icon(Icons.search),
          ),
          child: Text(
            _selected?.nameSearch ?? 'Selecciona una anomalía',
            style: TextStyle(
              color: _selected == null ? Theme.of(context).hintColor : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _AnomalyPickerDialog extends StatefulWidget {
  final AnomalyService service;
  const _AnomalyPickerDialog({required this.service});

  @override
  State<_AnomalyPickerDialog> createState() => _AnomalyPickerDialogState();
}

class _AnomalyPickerDialogState extends State<_AnomalyPickerDialog> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Anomaly>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.service.getAnomalies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    setState(() {
      _future = query.isEmpty
          ? widget.service.getAnomalies()
          : widget.service.searchAnomalies(query);
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
                hintText: 'Buscar por nombre, código o tipo...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onQueryChanged,
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: FutureBuilder<List<Anomaly>>(
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
                      final a = items[index];
                      return ListTile(
                        title: Text(a.nameSearch),
                        subtitle: a.name != null ? Text(a.name!) : null,
                        onTap: () => Navigator.pop(context, a),
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
