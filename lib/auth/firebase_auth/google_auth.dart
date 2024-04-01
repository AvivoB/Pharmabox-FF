import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pharmabox/constant.dart';
import 'package:pharmabox/custom_code/widgets/snackbar_message.dart';

final _googleSignIn = GoogleSignIn();

Future<UserCredential?> googleSignInFunc() async {
  if (kIsWeb) {
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
  }

  await signOutWithGoogle().catchError((_) => null);
  final auth = await (await _googleSignIn.signIn())?.authentication;
  if (auth == null) {
    return null;
  }
  final credential = GoogleAuthProvider.credential(idToken: auth.idToken, accessToken: auth.accessToken);
  return FirebaseAuth.instance.signInWithCredential(credential);
}

Future signOutWithGoogle() => _googleSignIn.signOut();






// Creation d'un compte avec un email et un mot de passe
Future<UserCredential?> createAccountWithGoogle(context, String poste) async {
  try {
     if (kIsWeb) {
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
  }

  await signOutWithGoogle().catchError((_) => null);
  final auth = await (await _googleSignIn.signIn())?.authentication;
  if (auth == null) {
    return null;
  }
  final credential = GoogleAuthProvider.credential(idToken: auth.idToken, accessToken: auth.accessToken);
   UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // Ajouter les champs supplémentaires à la collection "users" de Firestore
    await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
      'nom': userCredential.user!.displayName,
      'prenom': userCredential.user!.displayName,
      'poste': poste,
      'email': userCredential.user!.email,
      'uid': userCredential.user!.uid,
      'id': userCredential.user!.uid,
      'isValid': true,
      'isComplete': false,
      'isVerified': true,
    });

    return userCredential;
  } catch (e) {
    if ('email-already-in-use' == (e as FirebaseAuthException).code) {
      showCustomSnackBar(context, 'Cet email est déjà utilisé', isError: true);
    }
    if ('invalid-email' == (e as FirebaseAuthException).code) {
      showCustomSnackBar(context, 'Cet email est invalide', isError: true);
    }
    if ('weak-password' == (e as FirebaseAuthException).code) {
      showCustomSnackBar(context, 'Votre mot de passe est trop faible', isError: true);
    }
    print('Erreur lors de la création du compte : $e');
    return null;
  }
}
// Connexion d'un compte avec Google
Future<UserCredential?> connectAccountWithGoogle(context) async {
  try {
     if (kIsWeb) {
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
  }

  await signOutWithGoogle().catchError((_) => null);
  final auth = await (await _googleSignIn.signIn())?.authentication;
  if (auth == null) {
    return null;
  }
  final credential = GoogleAuthProvider.credential(idToken: auth.idToken, accessToken: auth.accessToken);
   UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
   
  FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get().then((value) async {
     if(value.exists){
      print('COMPTE EXISTE');
       return userCredential;  
     }else{
      print('compte existe pas');
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'nom': userCredential.user!.displayName,
        'prenom': userCredential.user!.displayName, 
        'poste': 'Pharmacien',
        'email': userCredential.user!.email,
        'uid': userCredential.user!.uid,
        'id': userCredential.user!.uid,
        'isValid': true,
        'isComplete': false,
        'isVerified': true,
      });
    }});


   

    return userCredential;
  } catch (e) {
    if ('email-already-in-use' == (e as FirebaseAuthException).code) {
      showCustomSnackBar(context, 'Cet email est déjà utilisé', isError: true);
    }
    if ('invalid-email' == (e as FirebaseAuthException).code) {
      showCustomSnackBar(context, 'Cet email est invalide', isError: true);
    }
    if ('weak-password' == (e as FirebaseAuthException).code) {
      showCustomSnackBar(context, 'Votre mot de passe est trop faible', isError: true);
    }
    print('Erreur lors de la création du compte : $e');
    return null;
  }
}

