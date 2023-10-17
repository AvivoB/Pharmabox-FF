import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constant.dart';

class ExplorerSearchData {
  // Créez un StreamController pour émettre les résultats de la recherche en temps réel.
  final StreamController<List<Map<String, dynamic>>> searchResultsStream = StreamController<List<Map<String, dynamic>>>();

  Future<void> searchUsers(String query) async {
    final lowerCaseQuery = query.toLowerCase();

    final usersRef = FirebaseFirestore.instance.collection('users');

    // Start by getting all users
    final usersSnapshot = await usersRef.where(FieldPath.documentId, isNotEqualTo: await getCurrentUserId()).get();

    // Prepare to launch search queries for each field
    final fields = ['nom', 'prenom', 'city', 'code_postal', 'poste', 'country'];

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

    searchResultsStream.add(uniqueUserData);
  }

  Future<void> searchPharmacies(String query) async {
    final lowerCaseQuery = query.toLowerCase();

    final pharmacieRef = FirebaseFirestore.instance.collection('pharmacies');

    // Start by getting all users
    final pharmacieSnapshot = await pharmacieRef.where('user_id', isNotEqualTo: await getCurrentUserId()).get();

    // Prepare to launch search queries for each field
    final fields = [
      'situation_geographique_adresse',
      'situation_geographique_data_postcode',
      'situation_geographique_data_region',
      'situation_geographique_data_rue',
      'situation_geographique_data_ville',
      'situation_geographique_data_country'
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

    searchResultsStream.add(uniquePharmacie);
  }

  void dispose() {
    searchResultsStream.close();
  }
}
