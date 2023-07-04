import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const redColor = Color(0xFFF89999);
const greenColor = Color(0xFF7CEDAC);
const yellowColor = Color(0xFFFDC571);
const blueColor = Color(0xFF42D2FF);
const greyColor = Color(0xFF595A71);
const greyLightColor = Color(0xFFEFF6F7);
const blackColor = Color(0xFF161730);

const googleMapsApi = 'AIzaSyBGiDwJv6PfzO6hPQeymoo7tl4NcdiyloQ';

Future<bool> checkIsTitulaire() async {
  final currentUser = FirebaseAuth.instance.currentUser;

  // Récupérer la référence de la collection d'utilisateurs
  final userCollection = FirebaseFirestore.instance.collection('users');

  // Récupérer le document de l'utilisateur courant à partir de Firestore
  final currentUserDoc = await userCollection.doc(currentUser!.uid).get();
  print(currentUserDoc.get('poste'));
  if (currentUserDoc.get('poste') == 'Pharmacien(ne) titulaire') {
    return true;
  } else {
    return false;
  }
}

Future<String> getPharmacyByUserId() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  String? currentUserId = auth.currentUser?.uid;

  QuerySnapshot querySnapshot = await firestore
      .collection('pharmacies')
      .where('user_id', isEqualTo: currentUserId)
      .limit(1)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    DocumentSnapshot document = querySnapshot.docs.first;
    return document.id.toString();
  } else {
    return '';
  }
}

Future<Map<String, dynamic>> getCurrentUserData() async {
  final user = FirebaseAuth.instance.currentUser;
  final userDoc = FirebaseFirestore.instance.collection('users').doc(user?.uid);
  DocumentSnapshot userSnapshot = await userDoc.get();

  // Vérifiez si le document utilisateur existe et contient des données
  if (userSnapshot.exists && userSnapshot.data() != null) {
    return userSnapshot.data() as Map<String, dynamic>;
  }

  return {};
}
