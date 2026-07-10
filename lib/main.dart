import 'package:acl_flutter/infrastructure/auth/auth_service.dart';
import 'package:acl_flutter/infrastructure/contacts/contact_service.dart';
import 'package:acl_flutter/infrastructure/notifications/notification_service.dart';
import 'package:acl_flutter/presentation/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/models/permissions/permission_status.dart';

enum AuthState { unknown, authenticated, notAuthenticated }

enum ContactState { unknown, granted, denied }

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final AuthService _authService = AuthService();
  AuthState _authState = AuthState
      .authenticated; // Lo cambio para probar las funciones sin tener que utilizar el emulador
  ContactState _contactState = ContactState.unknown;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final authenticated = await _authService.authenticate();
    if (!mounted) return;
    setState(() {
      _authState =
          authenticated ? AuthState.authenticated : AuthState.notAuthenticated;
    });
    if (!authenticated) return;

    await NotificationService.initNotifications();
    await NotificationService.requestNotificationsPermission();

    final status = await ContactService.requestPermission();
    if (!mounted) return;
    setState(() {
      _contactState = status == PermissionStatus.granted
          ? ContactState.granted
          : ContactState.denied;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_authState == AuthState.authenticated &&
        _contactState == ContactState.granted) {
      return const MaterialApp(title: "Homepage", home: HomePage());
    } else if (_authState == AuthState.notAuthenticated ||
        _contactState == ContactState.denied) {
      return MaterialApp(
        title: "Not authenticated",
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Not Authenticated"),
            centerTitle: true,
          ),
          body: Center(
            child: FloatingActionButton(
              onPressed: () => SystemNavigator.pop(),
              tooltip: "Cierra la aplicacion",
              child: const Icon(Icons.close),
            ),
          ),
        ),
      );
    } else {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
  }
}
