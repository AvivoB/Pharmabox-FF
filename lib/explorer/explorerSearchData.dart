import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constant.dart';

class ExplorerSearchData {
  Future<List> searchUsers(String query) async {
    final QuerySnapshot nomQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('nom', isGreaterThanOrEqualTo: query)
        .get();

    final QuerySnapshot prenomQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('prenom', isGreaterThanOrEqualTo: query)
        .get();

    final QuerySnapshot villeQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('city', isGreaterThanOrEqualTo: query)
        .get();
    final QuerySnapshot codePostalQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('code_postal', isGreaterThanOrEqualTo: query)
        .get();

    final Set<String> addedUserIds = {}; // Set to keep track of added user IDs
    final List<Map<String, dynamic>> uniqueUserData =
        []; // List to store unique user data

    void addUserIfNotAdded(DocumentSnapshot userDoc) {
      final String userId = userDoc.id;
      final Map<String, dynamic> userData =
          userDoc.data() as Map<String, dynamic>;

      // If the user ID is not in the set, add the user data to the list and the user ID to the set
      if (!addedUserIds.contains(userId)) {
        uniqueUserData.add(userData);
        addedUserIds.add(userId);
      }
    }

    // Process each query
    nomQuery.docs.forEach(addUserIfNotAdded);
    prenomQuery.docs.forEach(addUserIfNotAdded);
    villeQuery.docs.forEach(addUserIfNotAdded);
    codePostalQuery.docs.forEach(addUserIfNotAdded);

    return uniqueUserData;
  }

  Future<List> searchPharmacies(String query) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('pharmacies')
        .where('name', isGreaterThanOrEqualTo: query)
        .get();

    final QuerySnapshot nomPharmaquerySnapshot = await FirebaseFirestore
        .instance
        .collection('pharmacies')
        .where('situation_geographique.adresse', isGreaterThanOrEqualTo: query)
        .get();
    final QuerySnapshot adresse = await FirebaseFirestore.instance
        .collection('pharmacies')
        .where('situation_geographique.data.rue', isGreaterThanOrEqualTo: query)
        .get();
    final QuerySnapshot ville = await FirebaseFirestore.instance
        .collection('pharmacies')
        .where('situation_geographique.data.ville',
            isGreaterThanOrEqualTo: query)
        .get();
    final QuerySnapshot postcode = await FirebaseFirestore.instance
        .collection('pharmacies')
        .where('situation_geographique.data.ville',
            isGreaterThanOrEqualTo: query)
        .get();
    final QuerySnapshot region = await FirebaseFirestore.instance
        .collection('pharmacies')
        .where('situation_geographique.data.ville',
            isGreaterThanOrEqualTo: query)
        .get();

    final Set<String> addedPharmaid = {}; // Set to keep track of added user IDs
    final List<Map<String, dynamic>> uniquePharmaData =
        []; // List to store unique user data

    void addPharmaIfIsNotAdded(DocumentSnapshot pharmaDoc) {
      final String pharmaId = pharmaDoc.id;
      final Map<String, dynamic> pharmaData = pharmaDoc.data() as Map<String, dynamic>;
      pharmaData['documentId'] = pharmaId; // Add the documentId to the pharmaData map


      // If the user ID is not in the set, add the user data to the list and the user ID to the set
      if (!addedPharmaid.contains(pharmaId)) {
        uniquePharmaData.add(pharmaData);
        addedPharmaid.add(pharmaId);
      }
    }

    // Process each query
    querySnapshot.docs.forEach(addPharmaIfIsNotAdded);
    nomPharmaquerySnapshot.docs.forEach(addPharmaIfIsNotAdded);
    ville.docs.forEach(addPharmaIfIsNotAdded);
    adresse.docs.forEach(addPharmaIfIsNotAdded);
    postcode.docs.forEach(addPharmaIfIsNotAdded);
    region.docs.forEach(addPharmaIfIsNotAdded);

    // print(uniquePharmaData);
    return uniquePharmaData;
  }

  Future<List> searchJobs(String query) async {
    String collectionType = '';
    if (await checkIsTitulaire()) {
      collectionType = 'recherches';
    } else {
      collectionType = 'offres';
    }

    final QuerySnapshot villeQuery = await FirebaseFirestore.instance
        .collection(collectionType)
        .where('localisation', isGreaterThanOrEqualTo: query)
        .get();
    final QuerySnapshot contratQuery = await FirebaseFirestore.instance
        .collection(collectionType)
        .where('contrats', arrayContains: query)
        .get();

    final List<DocumentSnapshot> combinedResults = [
      ...villeQuery.docs,
      ...contratQuery.docs,
    ];

    List jobsData = [];
    for (final jobs in combinedResults) {
      jobsData.add(jobs.data());
    }

    return jobsData;
  }
}
