import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmabox/custom_code/widgets/snackbar_message.dart';


// Connexion avec un compte email et mot de passe
Future<UserCredential?> emailSignIn(context, String email,String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    return userCredential;
  } catch (e) {
    showCustomSnackBar(context, 'Identifiants incorrects', isError: true);
    print('Erreur de connexion : $e');
    return null;
  }
}


// Creation d'un compte avec un email et un mot de passe
Future<UserCredential?> createAccountWithEmail(context, String email, String password, String nom, String prenom, String poste) async {
  try {
    // Créer le compte utilisateur avec l'email et le mot de passe
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    // Ajouter les champs supplémentaires à la collection "users" de Firestore
    await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
      'nom': nom,
      'prenom': prenom,
      'poste': poste,
      'email': email,
      'uid': userCredential.user!.uid,
      'id': userCredential.user!.uid,
      'isValid': true,
      'isComplete': false,
      'isVerified': true,
    });

    return userCredential;
  } catch (e) {
    if('email-already-in-use' == (e as FirebaseAuthException).code){
      showCustomSnackBar(context, 'Cet email est déjà utilisé', isError: true);
    }
    if('invalid-email' == (e as FirebaseAuthException).code){
      showCustomSnackBar(context, 'Cet email est invalide', isError: true);
    }
    if('weak-password' == (e as FirebaseAuthException).code){
      showCustomSnackBar(context, 'Votre mot de passe est trop faible', isError: true);
    }
    print('Erreur lors de la création du compte : $e');
    return null;
  }
}