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

    final List<DocumentSnapshot> combinedResults = [
      ...nomQuery.docs,
      ...prenomQuery.docs,
      ...villeQuery.docs
    ];

    List userData = [];
    for (final user in combinedResults) {
      print(user);
      userData.add(user.data());
    }

    return userData;
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

    final List<DocumentSnapshot> combinedResults = [
      ...querySnapshot.docs,
      ...nomPharmaquerySnapshot.docs,
      ...region.docs,
      ...ville.docs,
      ...adresse.docs,
      ...postcode.docs,
    ];

    List pharmacieData = [];
    for (final pharmacie in combinedResults) {
      pharmacieData.add(pharmacie.data());
    }

    return pharmacieData;
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
