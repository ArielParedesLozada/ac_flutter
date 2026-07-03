import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<bool> authenticate() async {
    final bool deviceSupported = await _localAuthentication.isDeviceSupported();
    if (!deviceSupported) {
      return true;
    }
    try {
      return await _localAuthentication.authenticate(
        localizedReason: 'Please authenticate to access this feature',
      );
    } catch (e) {
      debugPrint('Auth error: $e');
      return false;
    }
  }
}
