import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constant.dart';

class ExplorerSearchData {
  Future<List> searchUsers(String query) async {
    final lowerCaseQuery = query.toLowerCase();

    final usersRef = FirebaseFirestore.instance.collection('users');

    // Start by getting all users
    final usersSnapshot = await usersRef.where(FieldPath.documentId, isNotEqualTo: await getCurrentUserId()).get();

    // Prepare to launch search queries for each field
    final fields = ['nom', 'prenom', 'city', 'code_postal', 'poste'];

    List<Future<QuerySnapshot>> searchDataFutures = [];

    usersSnapshot.docs.forEach((userDoc) {
      fields.forEach((field) {
        searchDataFutures.add(userDoc.reference.collection('searchData').where(field, isGreaterThanOrEqualTo: lowerCaseQuery).where(field, isLessThan: lowerCaseQuery + '\uf8ff').get());
      });
    });

    // Wait for all searchData queries to complete
    final List<QuerySnapshot> searchDataSnapshots = await Future.wait(searchDataFutures);

    // Now, get the parent user documents for each searchData document that matches the query
    final List<Future<DocumentSnapshot>> userFutures = searchDataSnapshots.expand((searchDataSnapshot) {
      return searchDataSnapshot.docs.map((searchDataDoc) {
        return usersRef.doc(searchDataDoc.id).get();
      });
    }).toList();

    // Wait for all user queries to complete
    List<DocumentSnapshot> userDocs = await Future.wait(userFutures);

    // Remove duplicate users and convert to list of user data
    final Set<String> addedUserIds = {}; // Set to keep track of added user IDs
    final List<Map<String, dynamic>> uniqueUserData = []; // List to store unique user data
    userDocs.forEach((userDoc) {
      final String userId = userDoc.id;
      final Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      if (!addedUserIds.contains(userId)) {
        uniqueUserData.add(userData);
        addedUserIds.add(userId);
      }
    });

    return uniqueUserData;
  }

  Future<List> searchPharmacies(String query) async {
    final lowerCaseQuery = query.toLowerCase();

    final pharmacieRef = FirebaseFirestore.instance.collection('pharmacies');

    // Start by getting all users
    final pharmacieSnapshot = await pharmacieRef.where(FieldPath.documentId, isNotEqualTo: await getCurrentUserId()).get();

    // Prepare to launch search queries for each field
    final fields = [
      'situation_geographique_adresse',
      'situation_geographique_data_postcode',
      'situation_geographique_data_region',
      'situation_geographique_data_rue',
      'situation_geographique_data_ville',
      'titulaire_principal',
    ];

    List<Future<QuerySnapshot>> searchDataFutures = [];

    pharmacieSnapshot.docs.forEach((userDoc) {
      fields.forEach((field) {
        searchDataFutures.add(userDoc.reference.collection('searchDataPharmacie').where(field, isGreaterThanOrEqualTo: lowerCaseQuery).where(field, isLessThan: lowerCaseQuery + '\uf8ff').get());
      });
    });

    // Wait for all searchData queries to complete
    final List<QuerySnapshot> searchDataSnapshots = await Future.wait(searchDataFutures);

    // Now, get the parent user documents for each searchData document that matches the query
    final List pharmacieFuture = searchDataSnapshots.expand((searchDataSnapshot) {
      return searchDataSnapshot.docs.map((searchDataDoc) {
        return pharmacieRef.doc(searchDataDoc.id).get();
      });
    }).toList();

    // Wait for all user queries to complete
    List<DocumentSnapshot> userDocs = await Future.wait(pharmacieFuture as Iterable<Future<DocumentSnapshot<Object?>>>);

    // Remove duplicate users and convert to list of user data
    final Set<String> addedUserIds = {}; // Set to keep track of added user IDs
    final List<Map<String, dynamic>> uniquePharmacie = []; // List to store unique user data
    userDocs.forEach((pharmacieDoc) {
      final String pharmacieId = pharmacieDoc.id;
      final Map<String, dynamic> userData = pharmacieDoc.data() as Map<String, dynamic>;
      if (!addedUserIds.contains(pharmacieId)) {
        userData['documentId'] = pharmacieId;
        uniquePharmacie.add(userData);
        addedUserIds.add(pharmacieId);
      }
    });

    print(uniquePharmacie);

    return uniquePharmacie;
  }

  // Future<List> searchPharmacies(String query) async {
  //   final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection('pharmacies')
  //       .where('name', isGreaterThanOrEqualTo: query)
  //       .get();

  //   final QuerySnapshot nomPharmaquerySnapshot = await FirebaseFirestore
  //       .instance
  //       .collection('pharmacies')
  //       .where('situation_geographique.adresse', isGreaterThanOrEqualTo: query)
  //       .get();
  //   final QuerySnapshot adresse = await FirebaseFirestore.instance
  //       .collection('pharmacies')
  //       .where('situation_geographique.data.rue', isGreaterThanOrEqualTo: query)
  //       .get();
  //   final QuerySnapshot ville = await FirebaseFirestore.instance
  //       .collection('pharmacies')
  //       .where('situation_geographique.data.ville',
  //           isGreaterThanOrEqualTo: query)
  //       .get();
  //   final QuerySnapshot postcode = await FirebaseFirestore.instance
  //       .collection('pharmacies')
  //       .where('situation_geographique.data.ville',
  //           isGreaterThanOrEqualTo: query)
  //       .get();
  //   final QuerySnapshot region = await FirebaseFirestore.instance
  //       .collection('pharmacies')
  //       .where('situation_geographique.data.ville',
  //           isGreaterThanOrEqualTo: query)
  //       .get();

  //   final Set<String> addedPharmaid = {}; // Set to keep track of added user IDs
  //   final List<Map<String, dynamic>> uniquePharmaData =
  //       []; // List to store unique user data

  //   void addPharmaIfIsNotAdded(DocumentSnapshot pharmaDoc) {
  //     final String pharmaId = pharmaDoc.id;
  //     final Map<String, dynamic> pharmaData =
  //         pharmaDoc.data() as Map<String, dynamic>;
  //     pharmaData['documentId'] =
  //         pharmaId; // Add the documentId to the pharmaData map

  //     // If the user ID is not in the set, add the user data to the list and the user ID to the set
  //     if (!addedPharmaid.contains(pharmaId)) {
  //       uniquePharmaData.add(pharmaData);
  //       addedPharmaid.add(pharmaId);
  //     }
  //   }

  //   // Process each query
  //   querySnapshot.docs.forEach(addPharmaIfIsNotAdded);
  //   nomPharmaquerySnapshot.docs.forEach(addPharmaIfIsNotAdded);
  //   ville.docs.forEach(addPharmaIfIsNotAdded);
  //   adresse.docs.forEach(addPharmaIfIsNotAdded);
  //   postcode.docs.forEach(addPharmaIfIsNotAdded);
  //   region.docs.forEach(addPharmaIfIsNotAdded);

  //   // print(uniquePharmaData);
  //   return uniquePharmaData;
  // }

  // Future<List> searchJobs(String query) async {
  //   String collectionType = '';
  //   if (await checkIsTitulaire()) {
  //     collectionType = 'recherches';
  //   } else {
  //     collectionType = 'offres';
  //   }

  //   final QuerySnapshot villeQuery = await FirebaseFirestore.instance
  //       .collection(collectionType)
  //       .where('localisation', isGreaterThanOrEqualTo: query)
  //       .get();
  //   final QuerySnapshot contratQuery = await FirebaseFirestore.instance
  //       .collection(collectionType)
  //       .where('contrats', arrayContains: query)
  //       .get();

  //   final List<DocumentSnapshot> combinedResults = [
  //     ...villeQuery.docs,
  //     ...contratQuery.docs,
  //   ];

  //   List jobsData = [];
  //   for (final jobs in combinedResults) {
  //     jobsData.add(jobs.data());
  //   }

  //   return jobsData;
  // }
}
