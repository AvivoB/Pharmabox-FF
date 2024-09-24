import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_theme.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_util.dart';
import 'package:provider/provider.dart';
import 'package:pharmabox/auth/AuthProvider.dart' as authProvider;

const redColor = Color(0xFFF89999);
const greenColor = Color(0xFF7CEDAC);
const yellowColor = Color(0xFFFDC571);
const blueColor = Color(0xFF42D2FF);
const greyColor = Color(0xFF595A71);
const greyLightColor = Color(0xFFEFF6F7);
const blackColor = Color(0xFF161730);

const googleMapsApi = 'AIzaSyBGiDwJv6PfzO6hPQeymoo7tl4NcdiyloQ';

Map<String, String> supportedCountry = {
  'France': 'fr',
  'Belgique': 'be',
  'Canada': 'ca',
  'Luxembourg': 'lu',
  'Monaco': 'mc',
  'Suisse': 'ch',
  'Guadeloupe': 'gp',
  'Martinique': 'mq',
  'Guyane': 'gf',
  'La Réunion': 're',
  'Mayotte': 'yt',
  'Saint-Pierre-et-Miquelon': 'pm',
  'Saint-Martin': 'mf',
  'Saint-Barthélemy': 'bl',
  'Wallis et Futuna': 'wf',
  'Polynésie française': 'pf',
  'Nouvelle-Calédonie': 'nc',
  'Terres australes et antarctiques françaises': 'tf',
};

Future<bool> checkIsTitulaire() async {
  final currentUser = FirebaseAuth.instance.currentUser;

  // Récupérer la référence de la collection d'utilisateurs
  final userCollection = FirebaseFirestore.instance.collection('users');

  // Récupérer le document de l'utilisateur courant à partir de Firestore
  final currentUserDoc = await userCollection.doc(currentUser!.uid).get();
  if (currentUserDoc.get('poste') == 'Pharmacien titulaire') {
    return true;
  } else {
    return false;
  }
}

Future<String> getPharmacyByUserId() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  String? currentUserId = auth.currentUser?.uid;

  QuerySnapshot querySnapshot = await firestore.collection('pharmacies').where('user_id', isEqualTo: currentUserId).limit(1).get();

  if (querySnapshot.docs.isNotEmpty) {
    DocumentSnapshot document = querySnapshot.docs.first;
    return document.id.toString();
  } else {
    return '';
  }
}

Future<Map<String, dynamic>> getCurrentUserData() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user?.uid);
    DocumentSnapshot userSnapshot = await userDoc.get();

    // Vérifiez si le document utilisateur existe et contient des données
    if (userSnapshot.exists && userSnapshot.data() != null) {
      return userSnapshot.data() as Map<String, dynamic>;
    }
  } catch (e) {}

  return {};
}

Future<String> getCurrentUserId() async {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  } else {
    return '';
  }
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

void showAlertCompleteProfile(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Votre profil est incomplet',
          style: FlutterFlowTheme.of(context).bodyLarge,
        ),
        content: Text('Pour augmenter votre visibilité sur Pharmabox, veuillez compléter votre profil.', style: FlutterFlowTheme.of(context).bodyMedium),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pushNamed('Profil');
            },
            child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Color(0x301F5C67),
                      offset: Offset(0, 4),
                    )
                  ],
                  gradient: LinearGradient(
                    colors: [Color(0xFF7CEDAC), Color(0xFF42D2FF)],
                    stops: [0, 1],
                    begin: AlignmentDirectional(1, -1),
                    end: AlignmentDirectional(-1, 1),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Compléter mon profil', style: FlutterFlowTheme.of(context).bodyMedium.copyWith(color: Colors.white)),
                )),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fermer l'alerte
              final authProviderData = Provider.of<authProvider.AuthProvider>(context, listen: false);
              authProviderData.setPLusTArd();
            },
            child: Text('Plus tard', style: FlutterFlowTheme.of(context).bodyMedium.copyWith(color: redColor)),
          ),
        ],
      );
    },
  );
}
void showDialogAlertCreatePharma(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Votre Pharmacie n\'est pas encore créé',
          style: FlutterFlowTheme.of(context).bodyLarge,
        ),
        content: Text('Veuillez compléter votre profil Pharmacie pour continuer.', style: FlutterFlowTheme.of(context).bodyMedium),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pushNamed('PharmacieProfil');
            },
            child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Color(0x301F5C67),
                      offset: Offset(0, 4),
                    )
                  ],
                  gradient: LinearGradient(
                    colors: [Color(0xFF7CEDAC), Color(0xFF42D2FF)],
                    stops: [0, 1],
                    begin: AlignmentDirectional(1, -1),
                    end: AlignmentDirectional(-1, 1),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Créer ma Pharmacie', style: FlutterFlowTheme.of(context).bodyMedium.copyWith(color: Colors.white)),
                )),
          ),
        ],
      );
    },
  );
}


void setStatistics(String type, String action) async {
  // Formater la date au format dd/MM/yyyy
  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now().toLocal());

  // Ajouter une entrée dans la collection des statistiques
  FirebaseFirestore.instance.collection('statistics').add({
    'type': type,
    'action': action,
    'created_at': formattedDate,
  });
}