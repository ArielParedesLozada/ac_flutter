import 'package:acl_flutter/app/topic_note_service.dart';
import 'package:acl_flutter/app/topic_service.dart';
import 'package:acl_flutter/domain/models/topic.dart';
import 'package:acl_flutter/presentation/widgets/topic_form.dart';
import 'package:acl_flutter/presentation/widgets/topic_item.dart';
import 'package:acl_flutter/presentation/widgets/topic_note_form.dart';
import 'package:flutter/material.dart';

class TopicsPage extends StatefulWidget {
  const TopicsPage({super.key});

  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  final TopicService _topicService = TopicService();
  final TopicNoteService _noteService = TopicNoteService();
  late Future<List<Topic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _topicService.getAllTopics();
  }

  void _refresh() {
    setState(() {
      _future = _topicService.getAllTopics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temas'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: _TopicSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 140, 197, 243),
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Topic>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final topics = snapshot.data!;
          if (topics.isEmpty) {
            return const Center(child: Text('No hay temas registrados'));
          }
          return ListView.builder(
            itemCount: topics.length,
            itemBuilder: (context, index) => Container(
              padding: const EdgeInsets.all(5),
              child: Dismissible(
                key: Key(topics[index].id.toString()),
                background: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.green,
                  alignment: Alignment.centerLeft,
                  child: const Icon(Icons.note_add),
                ),
                secondaryBackground: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.delete),
                ),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    _showAddNoteDialog(topics[index]);
                  } else {
                    await _confirmDelete(topics[index]);
                  }
                  return null;
                },
                onDismissed: (_) => _refresh(),
                child: TopicItem(
                  topic: topics[index],
                  onReturn: _refresh,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddNoteDialog(Topic topic) {
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
                  initialTopic: topic,
                  onSubmit: (dto) async {
                    await _noteService.createNote(dto);
                    if (!context.mounted) return;
                    Navigator.pop(dialogContext);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateDialog() {
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
                  'Nuevo tema',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: TopicForm(
                    onSubmit: (dto) async {
                      await _topicService.createTopic(dto);
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

  Future<void> _confirmDelete(Topic topic) async {
    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Estás seguro que quieres eliminar este tema?'),
        actions: [
          TextButton(
            onPressed: () async {
              await _topicService.deleteTopic(topic.id!);
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

class _TopicSearchDelegate extends SearchDelegate {
  final TopicService _topicService = TopicService();

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
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    return FutureBuilder<List<Topic>>(
      future: _topicService.searchTopics(query),
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
          itemBuilder: (context, index) => TopicItem(topic: results[index]),
        );
      },
    );
  }
}
