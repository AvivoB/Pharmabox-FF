import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:pharmabox/constant.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Generates a cryptographically secure random nonce, to be included in a
/// credential request.
String generateNonce([int length = 32]) {
  final charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
}

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

Future<UserCredential> appleSignIn() async {
  // if (kIsWeb) {
  //   final provider = OAuthProvider("apple.com")
  //     ..addScope('email')
  //     ..addScope('name');

  //   // Sign in the user with Firebase.
  //   return await FirebaseAuth.instance.signInWithPopup(provider);
  // }
  // // To prevent replay attacks with the credential returned from Apple, we
  // // include a nonce in the credential request. When signing in in with
  // // Firebase, the nonce in the id token returned by Apple, is expected to
  // // match the sha256 hash of `rawNonce`.
  if (Platform.isIOS) {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  } else {
    final appleProvider = AppleAuthProvider().addScope('email').addScope('name');
    return await FirebaseAuth.instance.signInWithProvider(appleProvider);
  }

  // Sign in the user with Firebase. If the nonce we generated earlier does
  // not match the nonce in `appleCredential.identityToken`, sign in will fail.
}

Future<UserCredential> signInWithApple(context, String poste) async {
  final appleProvider = AppleAuthProvider();
  appleProvider.addScope('email');
  appleProvider.addScope('name');
  if (kIsWeb) {
    return await FirebaseAuth.instance.signInWithPopup(appleProvider);
  }

  UserCredential userCredential = await FirebaseAuth.instance.signInWithProvider(appleProvider);

  // Ajouter les champs supplémentaires à la collection "users" de Firestore
  await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
    'nom': extractNameFromEmail(userCredential.user?.email ?? '')[0].toString(),
    'prenom': extractNameFromEmail(userCredential.user?.email ?? '')[1].toString(),
    'poste': poste,
    'email': userCredential.user?.email ?? '',
    'uid': userCredential.user!.uid,
    'id': userCredential.user!.uid,
    'isValid': true,
    'isComplete': false,
    'isVerified': true,
  });

  return userCredential;
}


// Connexion d'un compte avec Google
Future<UserCredential?> connectAccountWithApple(context) async {
final appleProvider = AppleAuthProvider();
  appleProvider.addScope('email');
  appleProvider.addScope('name');
  if (kIsWeb) {
    return await FirebaseAuth.instance.signInWithPopup(appleProvider);
  }

  UserCredential userCredential = await FirebaseAuth.instance.signInWithProvider(appleProvider);

  // Ajouter les champs supplémentaires à la collection "users" de Firestore
  FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get().then((value) async {
     if(value.exists){
       return userCredential;  
     }else{
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'nom': extractNameFromEmail(userCredential.user!.email ?? '')[0].toString(),
        'prenom': extractNameFromEmail(userCredential.user!.email ?? '')[1].toString(),
        'poste': 'Pharmacien',
        'email': userCredential.user!.email,
        'uid': userCredential.user!.uid,
        'id': userCredential.user!.uid,
        'isValid': true,
        'isComplete': false,
        'isVerified': true,
      });
    }});
}

// fonction pour changer l'email en nom et prenom en retirant tout ce qui est apres le @ et les chiffres et renvoyer le nom et prenom sous forme de tableau pour avoir le nom et le prénon séparé
List<String> extractNameFromEmail(String email) {
  List<String> parts = email.split('@')[0].split('.');
  
  if (parts.length == 1) {
    // S'il n'y a pas de ".", considérons tout le nom comme le prénom
    String firstName = parts[0].replaceAll(RegExp(r'[0-9]'), '').toCapitalized();
    return [firstName, ''];
  }
  
  // Si un "." est trouvé, supposons que la partie avant le "." est le prénom et après est le nom
  String firstName = parts[0].replaceAll(RegExp(r'[0-9]'), '').toCapitalized();
  String lastName = parts.sublist(1).join('.').replaceAll(RegExp(r'[0-9]'), '').toCapitalized();

  return [firstName, lastName];
}