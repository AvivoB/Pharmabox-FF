import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  Map<String, dynamic>? _userData;
  bool _isValid = false;
  bool _isComplete = false;
  bool _isVerified = false;
  bool _duringRegister = true;
  bool _isLoadingAuth = true;

  bool _isPLusTArd = false;

  User? get user => _user;
  Map<String, dynamic>? get userData => _userData;

  bool get isValid => _isValid;
  bool get isComplete => _isComplete;
  bool get isVerified => _isVerified;
  bool get duringRegister => _duringRegister;
  bool get isLoadingAuth => _isLoadingAuth;
  bool get isPLusTArd => _isPLusTArd;

  AuthProvider() {
    _auth.authStateChanges().listen((User? newUser) async {
      _user = newUser;
      if (_user != null) {
        // Récupérer les données utilisateur depuis Firestore
        await _fetchUserData();
        _isValid = _userData?['isValid'] ?? false;
        _isComplete = _userData?['isComplete'] ?? false;
        _isVerified = _userData?['isVerified'] ?? false;
        _duringRegister = false;
      }
      _isLoadingAuth = false;
      notifyListeners();
    });
  }

  void setValidCode() {
    _isVerified = true;
  }

  void setComplete() {
    _isComplete = true;
  }

  void setDuringRegister() {
    _duringRegister = true;
  }

  void setPLusTArd() {
    _isPLusTArd = true;
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      // Gérer les erreurs d'authentification
      print('Erreur de connexion: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _userData = null;
    notifyListeners();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(_user!.uid).get();
      _userData = userDoc.data() as Map<String, dynamic>?;

      notifyListeners();
    } catch (e) {
      // Gérer les erreurs de récupération des données utilisateur
      print('Erreur de récupération des données utilisateur: $e');
    }
  }
}
