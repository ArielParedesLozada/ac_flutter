import 'package:acl_flutter/infrastructure/auth/auth_service.dart';
import 'package:acl_flutter/presentation/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AuthState { unknown, authenticated, notAuthenticated }

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
  AuthState _authState = AuthState.unknown;

  @override
  void initState() {
    super.initState();
    _authService.authenticate().then((bool result) {
      if (!mounted) return;
      setState(() {
        _authState = result ? AuthState.authenticated : AuthState.notAuthenticated;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authState) {
      case AuthState.unknown:
        return const MaterialApp(
          home: Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      case AuthState.authenticated:
        return const MaterialApp(
          title: "Named routes",
          home: HomePage(),
        );
      case AuthState.notAuthenticated:
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
    }
  }
}
