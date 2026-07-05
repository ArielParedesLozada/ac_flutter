import 'package:acl_flutter/app/anomaly_service.dart';
import 'package:acl_flutter/domain/models/anomaly.dart';
import 'package:acl_flutter/presentation/widgets/anomaly_form.dart';
import 'package:acl_flutter/presentation/widgets/anomaly_item.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter/material.dart';

class AnomaliesPage extends StatefulWidget {
  const AnomaliesPage({super.key});

  @override
  State<AnomaliesPage> createState() => _TestPageState();
}

class _TestPageState extends State<AnomaliesPage> {
  final AnomalyService anomalyService = AnomalyService();
  late final _pagingController = PagingController<int, Anomaly>(
    getNextPageKey: (state) => state.pages?.last.lastOrNull?.id ?? 0,
    fetchPage: (pageKey) => nextPage(pageKey), // Callback to fetch data
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Muestra a anomalias"),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: _CustomSearchDelegate());
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue[300],
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
        onPressed: showAnomalyForm,
      ),
      body: Center(
        child: PagingListener(
          controller: _pagingController,
          builder: (context, state, fetchNextPage) =>
              PagedListView<int, Anomaly>(
                state: state,
                fetchNextPage: fetchNextPage,
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (context, item, index) => Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue),
                    ),
                    child: AnomalyItem(anomaly: item),
                  ),
                ),
              ),
        ),
      ),
    );
  }

  Future<List<Anomaly>> nextPage(int page) async {
    int pageSize = 10;
    List<Anomaly> list = await anomalyService.getPagedAnomalies(page, pageSize);
    return list;
  }

  void showAnomalyForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Registra una anomalia"),
        content: SingleChildScrollView(
          child: AnomalyForm(
            onSubmit: (dto) async {
              await anomalyService.createAnomaly(dto);
              if (mounted) Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
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
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Anomaly>>(
      future: anomalyService.getAnomalyByName(query),
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
      future: anomalyService.getAnomalyByName(query),
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
