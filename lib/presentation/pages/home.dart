import 'package:acl_flutter/presentation/pages/test.dart';
import 'package:flutter/material.dart';

class _NavDestination {
  const _NavDestination({
    required this.icon,
    required this.label,
    required this.page,
  });

  final IconData icon;
  final String label;
  final Widget page;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<_NavDestination> _destinations = [
    _NavDestination(
      icon: Icons.home_outlined,
      label: 'Inicio',
      page: const _HomeBody(),
    ),
    _NavDestination(
      icon: Icons.list_alt_outlined,
      label: 'Anomalías',
      page: const TestPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [for (final d in _destinations) d.page],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: [
          for (final d in _destinations)
            NavigationDestination(icon: Icon(d.icon), label: d.label),
        ],
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Home')),
      body: const Center(child: Text('Sigma sdcsd')),
    );
  }
}
