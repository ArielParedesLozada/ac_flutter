import 'package:acl_flutter/app/anomaly_note_service.dart';
import 'package:acl_flutter/app/anomaly_service.dart';
import 'package:acl_flutter/domain/models/anomaly_note.dart';
import 'package:acl_flutter/presentation/widgets/anomaly_note_form.dart';
import 'package:acl_flutter/presentation/widgets/anomaly_note_item.dart';
import 'package:flutter/material.dart';

class AnomalyNotesPage extends StatefulWidget {
  const AnomalyNotesPage({super.key});

  @override
  State<AnomalyNotesPage> createState() => _AnomalyNotesPageState();
}

class _AnomalyNotesPageState extends State<AnomalyNotesPage> {
  final anomalyService = AnomalyService();
  final anomalyNotesService = AnomalyNoteService();
  late Future<List<AnomalyNote>> _future;

  @override
  void initState() {
    super.initState();
    _future = anomalyNotesService.getAllAnomalyNotes();
  }

  void _showNoteForm() {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Nueva nota',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                AnomalyNoteForm(
                  onSubmit: (dto) async {
                    await anomalyNotesService.createAnomalyNote(dto);
                    if (!context.mounted) return;
                    Navigator.pop(dialogContext);
                    _refresh();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _refresh() {
    setState(() {
      _future = anomalyNotesService.getAllAnomalyNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notas de las anomalías"),
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
        onPressed: _showNoteForm,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final notes = snapshot.data!;
          if (notes.isEmpty) {
            return const Center(child: Text('No hay anomalías registradas'));
          }
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) => Container(
              padding: const EdgeInsets.all(5),
              child: AnomalyNoteItem(anomalyNote: notes[index]),
            ),
          );
        },
      ),
    );
  }
}

class _CustomSearchDelegate extends SearchDelegate {
  final notesService = AnomalyNoteService();

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
    return FutureBuilder<List<AnomalyNote>>(
      future: notesService.searchNotes(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final results = snapshot.data!;
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) =>
              AnomalyNoteItem(anomalyNote: results[index]),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<AnomalyNote>>(
      future: notesService.searchNotes(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final results = snapshot.data!;
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) =>
              AnomalyNoteItem(anomalyNote: results[index]),
        );
      },
    );
  }
}
