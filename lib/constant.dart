import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const redColor = Color(0xFFe21c3d);
const greenColor = Color(0xFF7CEDAC);
const yellowColor = Color(0xFFFDC571);
const greyColor = Color(0xFF595A71);

const googleMapsApi = 'AIzaSyBGiDwJv6PfzO6hPQeymoo7tl4NcdiyloQ';

Future<bool> checkIsTitulaire() async {
  final currentUser = FirebaseAuth.instance.currentUser;

  // Récupérer la référence de la collection d'utilisateurs
  final userCollection = FirebaseFirestore.instance.collection('users');

  // Récupérer le document de l'utilisateur courant à partir de Firestore
  final currentUserDoc = await userCollection.doc(currentUser!.uid).get();
  print(currentUserDoc.get('poste'));
  // if (currentUserDoc.get('poste') == 'Pharmacien(ne) titulaire') {
  //   return true;
  // } else {
  //   return false;
  // }

  return true;
}
