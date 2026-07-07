import 'package:acl_flutter/app/anomaly_service.dart';
import 'package:acl_flutter/domain/models/anomaly.dart';
import 'package:acl_flutter/presentation/widgets/anomaly_form.dart';
import 'package:acl_flutter/presentation/widgets/anomaly_item.dart';
import 'package:flutter/material.dart';

class AnomaliesPage extends StatefulWidget {
  const AnomaliesPage({super.key});

  @override
  State<AnomaliesPage> createState() => _TestPageState();
}

class _TestPageState extends State<AnomaliesPage> {
  final AnomalyService anomalyService = AnomalyService();
  late Future<List<Anomaly>> _future;

  @override
  void initState() {
    super.initState();
    _future = anomalyService.getAnomalies();
  }

  void _refresh() {
    setState(() {
      _future = anomalyService.getAnomalies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anomalías registradas"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: _CustomSearchDelegate());
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 140, 197, 243),
        onPressed: showAnomalyForm,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Anomaly>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final anomalies = snapshot.data!;
          if (anomalies.isEmpty) {
            return const Center(child: Text('No hay anomalías registradas'));
          }
          return ListView.builder(
            itemCount: anomalies.length,
            itemBuilder: (context, index) => Container(
              padding: const EdgeInsets.all(5),
              child: Dismissible(
                key: Key(anomalies[index].toString()),
                onDismissed: (direction) {
                  setState(() {
                    _future = anomalyService.getAnomalies();
                  });
                },
                confirmDismiss: (direction) async {
                  _confirmDismiss(anomalies[index]);
                  return null;
                },
                child: AnomalyItem(
                  anomaly: anomalies[index],
                  onReturn: _refresh,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void showAnomalyForm() {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 20, 24, 8),
                child: Text(
                  "Registra una anomalía",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: AnomalyForm(
                    onSubmit: (dto) async {
                      await anomalyService.createAnomaly(dto);
                      if (!context.mounted) return;
                      Navigator.pop(dialogContext);
                      _refresh();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDismiss(Anomaly anomaly) async {
    return await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Confirmar"),
          content: const Text("¿Estás seguro que quieres eliminar?"),
          actions: [
            TextButton(
              onPressed: () async {
                await anomalyService.deleteAnomaly(anomaly);
                if (!context.mounted) return;
                Navigator.pop(dialogContext);
                _refresh();
              },
              child: const Text("ELIMINAR"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("CANCELAR"),
            ),
          ],
        );
      },
    );
  }
}

class _CustomSearchDelegate extends SearchDelegate {
  final AnomalyService anomalyService = AnomalyService();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Anomaly>>(
      future: anomalyService.searchAnomalies(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final results = snapshot.data!;
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) => AnomalyItem(anomaly: results[index]),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Anomaly>>(
      future: anomalyService.searchAnomalies(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final results = snapshot.data!;
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) => AnomalyItem(anomaly: results[index]),
        );
      },
    );
  }
}
