import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:io';

class AppSingleton {
  static final AppSingleton _instance = AppSingleton._internal();
  static AppSingleton get instance => _instance;
  AppSingleton._internal();
  bool isAuthenticated = false;
}

class PerformAppAuthentication {
  static final LocalAuthentication localAuth = LocalAuthentication();

  /// [authenticate] performs app authentication every time
  /// when the app is opened or resumed.
  static Future<void> authenticate() async {
    bool isAuth = false;
    try {
      // Perform authentication with device-specific techniques
      isAuth = await localAuth.authenticate(
        localizedReason: 'Please authenticate to access the app',
      );
      AppSingleton.instance.isAuthenticated = isAuth;
      // Close app if the user doesn't authenticate
      if (!isAuth) {
        exit(0);
      }
    } on PlatformException catch (e) {
      // Close app if the user cancels authentication on iOS
      if (Platform.isIOS && e.message == "Authentication canceled.") {
        exit(0);
      }
    }
  }
}
