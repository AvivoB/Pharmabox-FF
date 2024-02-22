import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:pharmabox/auth/base_auth_user_provider.dart';

class AppStateNotifier extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  User? get user => _user;
  String? _redirectLocation;
  bool _authDataReady = false;
  bool get authDataReady => _authDataReady;


  AppStateNotifier() {
    // Écoute les changements d'état d'authentification
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      _authDataReady = true; // Marquer que les données d'authentification sont prêtes
      notifyListeners();
    });
  }

  bool get loggedIn => _user != null;
  bool get initiallyLoggedIn => _user?.uid != null;
  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  update(BaseAuthUser user) {}
}
