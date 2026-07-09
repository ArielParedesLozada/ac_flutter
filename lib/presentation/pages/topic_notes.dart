import 'package:acl_flutter/app/topic_note_service.dart';
import 'package:acl_flutter/domain/models/topic_note.dart';
import 'package:acl_flutter/presentation/widgets/topic_note_form.dart';
import 'package:acl_flutter/presentation/widgets/topic_note_item.dart';
import 'package:flutter/material.dart';

class TopicNotesPage extends StatefulWidget {
  const TopicNotesPage({super.key});

  @override
  State<TopicNotesPage> createState() => _TopicNotesPageState();
}

class _TopicNotesPageState extends State<TopicNotesPage> {
  final TopicNoteService _noteService = TopicNoteService();
  late Future<List<TopicNote>> _future;

  @override
  void initState() {
    super.initState();
    _future = _noteService.getAllTopicNotes();
  }

  void _refresh() {
    setState(() {
      _future = _noteService.getAllTopicNotes();
    });
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
                TopicNoteForm(
                  onSubmit: (dto) async {
                    await _noteService.createNote(dto);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas de temas'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: _TopicNoteSearchDelegate(),
              );
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
      body: FutureBuilder<List<TopicNote>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final notes = snapshot.data!;
          if (notes.isEmpty) {
            return const Center(child: Text('No hay notas registradas'));
          }
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) => Container(
              padding: const EdgeInsets.all(5),
              child: Dismissible(
                key: Key(notes[index].id.toString()),
                background: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  child: const Icon(Icons.delete),
                ),
                secondaryBackground: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.delete),
                ),
                confirmDismiss: (_) async {
                  await _confirmDelete(notes[index]);
                  return null;
                },
                onDismissed: (_) => _refresh(),
                child: TopicNoteItem(topicNote: notes[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(TopicNote note) async {
    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Estás seguro que quieres eliminar esta nota?'),
        actions: [
          TextButton(
            onPressed: () async {
              await _noteService.deleteNote(note);
              if (!context.mounted) return;
              Navigator.pop(dialogContext);
              _refresh();
            },
            child: const Text('ELIMINAR'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('CANCELAR'),
          ),
        ],
      ),
    );
  }
}

class _TopicNoteSearchDelegate extends SearchDelegate {
  final TopicNoteService _noteService = TopicNoteService();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildList();

  @override
  Widget buildSuggestions(BuildContext context) => _buildList();

  Widget _buildList() {
    return FutureBuilder<List<TopicNote>>(
      future: _noteService.searchNotes(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final results = snapshot.data!;
        if (results.isEmpty) {
          return const Center(child: Text('Sin resultados'));
        }
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) =>
              TopicNoteItem(topicNote: results[index]),
        );
      },
    );
  }
}
