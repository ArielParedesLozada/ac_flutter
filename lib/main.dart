import 'package:acl_flutter/infrastructure/auth/auth.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PerformAppAuthentication.authenticate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Hola papu")),
        body: Center(child: Text("App iniciada")),
      ),
    );
  }
}
