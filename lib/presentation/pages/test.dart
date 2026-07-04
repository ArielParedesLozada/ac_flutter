import 'package:acl_flutter/app/anomaly_service.dart';
import 'package:acl_flutter/domain/models/anomaly.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
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
        centerTitle: true,
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
                    child: Text(item.name ?? ""),
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

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
