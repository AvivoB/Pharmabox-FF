import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  /// Additional helper methods are added here.
  // Récupère les LGO firebase
  Future<List> getAllLgo() async {
    // Récupération de la collection Firestore
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('lgo');
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Récupération des documents dans la collection
    List<dynamic> results = [];
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      // Récupération des champs ID et nom
      dynamic data = doc.data();
      String id = doc.id;
      String name = data['name'];

      // Récupération de l'image depuis Firebase Storage
      String imagePath = data['imagePath'];
      Reference ref = FirebaseStorage.instance.ref(imagePath);
      String imageUrl = await ref.getDownloadURL();

      // Ajout de l'élément dans le tableau de résultats
      results.add({
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
      });
    }

    return results;
  }
}
