import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';
import 'dart:async';

class PopupLgoModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this component.

  // State field(s) for LgoFilter widget.
  TextEditingController? lgoFilterController;
  String? Function(BuildContext, String?)? lgoFilterControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    lgoFilterController?.dispose();
  }

  // Liste les lgo selectionnés pour les renvoyer vers RegisterStepWidget
  static List<Map> selectedLGO = [];

  /// Additional helper methods are added here.
  // Récupère les LGO firebase
  // static Future<List<Map>> getAllLgo() async {
  //   // Récupération de la collection Firestore
  //   Query<Map<String, dynamic>> collectionRef = FirebaseFirestore.instance.collection('lgo').orderBy('name');
  //   QuerySnapshot querySnapshot = await collectionRef.get();

  //   // Récupération des documents dans la collection
  //   List<Map> results = [];
  //   for (QueryDocumentSnapshot doc in querySnapshot.docs) {
  //     // Récupération des champs ID et nom
  //     dynamic data = doc.data();
  //     String id = doc.id;
  //     String name = data['name'];

  //     // Récupération de l'image depuis Firebase Storage
  //     var imagePath = data['image'];
  //     Reference ref = FirebaseStorage.instance.ref();
  //     var imageUrl = await ref.child('lgo/' + imagePath).getDownloadURL();

  //     // Ajout de l'élément dans le tableau de résultats
  //     results.add({
  //       'id': id,
  //       'name': name,
  //       'imageUrl': imageUrl,
  //     });
  //   }

  //   return results.toList();
  // }

  // Recupere les LGO dans le stockage local
  static selectLGO() {

    List<Map> listLGO = [
      {"image": "ActiPharm.jpg", "name": "ActiPharm"},
      {"image": "CADUCIEL.jpg", "name": "CADUCIEL"},
      {"image": "Crystal.jpg", "name": "Crystal"},
      {"image": "Leo.jpg", "name": "Léo"},
      {"image": "LGPI.jpg", "name": "LGPI"},
      {"image": "Pharmagest.jpg", "name": "Pharmagest"},
      {"image": "Pharmaland.jpg", "name": "Pharmaland"},
      {"image": "PharmaVitale.jpg", "name": "PharmaVitale"},
      {"image": "Pharmony.jpg", "name": "Pharmony"},
      {"image": "SMART_RX.jpg", "name": "SMART RX"},
      {"image": "Vindilis.jpg", "name": "Vindilis"},
      {"image": "Visiopharm.jpg", "name": "Visiopharm"},
      {"image": "Winpharma.jpg", "name": "Winpharma"}
    ];


     final sorted = listLGO.toList()..sort((a, b)=> a['name'].compareTo(b['name']));

    return listLGO.toList();
  }
}
