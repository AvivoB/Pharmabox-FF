import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constant.dart';

class ExplorerSearchData {
  Future<List<DocumentSnapshot>> searchUsers(String query) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .get();

    final QuerySnapshot firstNameQuerySnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('prenom', isGreaterThanOrEqualTo: query)
        .get();

    final QuerySnapshot cityQuerySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('city', isGreaterThanOrEqualTo: query)
        .get();

    final List<DocumentSnapshot> combinedResults = [
      ...querySnapshot.docs,
      ...firstNameQuerySnapshot.docs,
      ...cityQuerySnapshot.docs
    ];

    return combinedResults;
  }

  Future<List<DocumentSnapshot>> searchPharmacies(String query) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('pharmacies')
        .where('name', isGreaterThanOrEqualTo: query)
        .get();

    final QuerySnapshot nomPharmaquerySnapshot = await FirebaseFirestore
        .instance
        .collection('pharmacies')
        .where('situation_geographique.adresse', isGreaterThanOrEqualTo: query)
        .get();
    final QuerySnapshot adresse = await FirebaseFirestore
        .instance
        .collection('pharmacies')
        .where('situation_geographique.data.rue', isGreaterThanOrEqualTo: query)
        .get();
    final QuerySnapshot ville = await FirebaseFirestore
        .instance
        .collection('pharmacies')
        .where('situation_geographique.data.ville', isGreaterThanOrEqualTo: query)
        .get();
    final QuerySnapshot postcode = await FirebaseFirestore
        .instance
        .collection('pharmacies')
        .where('situation_geographique.data.ville', isGreaterThanOrEqualTo: query)
        .get();
    final QuerySnapshot region = await FirebaseFirestore
        .instance
        .collection('pharmacies')
        .where('situation_geographique.data.ville', isGreaterThanOrEqualTo: query)
        .get();

    final List<DocumentSnapshot> combinedResults = [
      ...querySnapshot.docs,
      ...nomPharmaquerySnapshot.docs,
      ...region.docs,
      ...ville.docs,
      ...adresse.docs,
      ...postcode.docs,

    ];

    return combinedResults;
  }

  Future searchAndListData(String query) async {
    final List<DocumentSnapshot> users = await searchUsers(query);
    final List<DocumentSnapshot> pharmacies = await searchPharmacies(query);

    List pharma = [];
    List utilisateurs = [];

    // // Afficher les utilisateurs trouvés
    print('Utilisateurs trouvés :');
    for (final user in users) {
      utilisateurs.add(user.data());
    }

    // Afficher les pharmacies trouvées
    print('Pharmacies trouvées :');
    for (final pharmacy in pharmacies) {
      pharma.add(pharmacy.data());
    }
    
    return [pharma, utilisateurs];
  }
}

