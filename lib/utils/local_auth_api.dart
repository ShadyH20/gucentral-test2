import 'package:flutter/services.dart';
import 'package:gucentral/widgets/Requests.dart';
// import 'package:local_auth/';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    print("Biometric available? $isAvailable");
    // print(await _auth.getAvailableBiometrics());
    if (!isAvailable) return false;

    try {
      return await _auth.authenticate(
          localizedReason:
              'Please authenticate to ${(prefs.getBool('lock') ?? false) ? "unlock" : "lock"} GUCentral',
          options: const AuthenticationOptions(
              stickyAuth: true, useErrorDialogs: true));
    } on PlatformException catch (e) {
      print("Plat exception");
      return false;
    }
  }
}
