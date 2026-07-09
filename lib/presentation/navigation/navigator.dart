import 'package:acl_flutter/presentation/pages/anomalies.dart';
import 'package:acl_flutter/presentation/pages/anomaly_notes.dart';
import 'package:acl_flutter/presentation/pages/topic_notes.dart';
import 'package:acl_flutter/presentation/pages/topics.dart';
import 'package:flutter/material.dart';

class NavDestination {
  const NavDestination({
    required this.icon,
    required this.label,
    required this.page,
  });

  final IconData icon;
  final String label;
  final Widget page;
}

class NavList {
  static final List<NavDestination> destinations = [
    NavDestination(
      icon: Icons.list_alt_outlined,
      label: 'Anomalías',
      page: const AnomaliesPage(),
    ),
    NavDestination(
      icon: Icons.notes,
      label: "Notas",
      page: const AnomalyNotesPage(),
    ),
    NavDestination(
      icon: Icons.home_outlined,
      label: 'To do',
      page: const TopicNotesPage(),
    ),
    NavDestination(
      icon: Icons.home_outlined,
      label: 'Temas',
      page: const TopicsPage(),
    ),
  ];
}
