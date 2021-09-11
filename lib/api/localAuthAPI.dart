import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    final isAvailable = await hasBiometric();
    if (!isAvailable) {
      return false;
    }

    try {
      return await _auth.authenticate(
          localizedReason: 'To Access Your Passwords',
          useErrorDialogs: true,
          stickyAuth: true);
    } on PlatformException catch (e) {
      return false;
    }
  }

  static hasBiometric() {
    try {
      return _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }
}
