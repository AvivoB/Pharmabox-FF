import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constant.dart';

class PharmaJobSearchData {
  // Recherche des offres en fonctions des filtres de recherche
  Future<List> filterRechercheToFindOffre(filters) async {
    CollectionReference offres =
        FirebaseFirestore.instance.collection('offres');
    Query filteredQuery = offres;
    print("----------FILTERS NORMAL-------------");
    print(filters);
    print("----------END---FILTERS-------------");

    // Recherche par contrat OK
    if (!filters['contrats'].contains('Intérimaire') &&
        filters['contrats'] != null &&
        filters['contrats'].isNotEmpty) {
      filteredQuery = filteredQuery.where('contrats',
          arrayContainsAny: filters['contrats']);
    }

    if (filters['debut_contrat'] != '') {
      filteredQuery = filteredQuery.where('debut_contrat',
          isEqualTo: filters['debut_contrat']);
    }

    if (filters['debut_immediat'] != false) {
      filteredQuery = filteredQuery.where('debut_immediat',
          isEqualTo: filters['debut_immediat']);
    }

    if (filters['duree'] != '') {
      filteredQuery = filteredQuery.where('duree', isEqualTo: filters['duree']);
    }

    if (filters['grille_horaire'] != '') {
      filteredQuery = filteredQuery.where('grille_horaire',
          isEqualTo: filters['grille_horaire']);
    }

    if (filters['grille_horaire_impaire'] != '') {
      filteredQuery = filteredQuery.where('grille_horaire_impaire',
          isEqualTo: filters['grille_horaire_impaire']);
    }

    if (filters['grille_pair_impaire_identique'] != false) {
      filteredQuery = filteredQuery.where('grille_pair_impaire_identique',
          isEqualTo: filters['grille_pair_impaire_identique']);
    }

    if (filters['horaire_dispo_interim'] != null &&
        filters['horaire_dispo_interim'].isNotEmpty &&
        filters['contrats'].contains('Intérimaire')) {
      filteredQuery = filteredQuery.where('proposition_dispo_interim',
          arrayContainsAny: filters['horaire_dispo_interim']);
    }

    if (filters['salaire_mensuel'] != '') {
      filteredQuery = filteredQuery.where('salaire_mensuel',
          isEqualTo: filters['salaire_mensuel']);
    }

    if (filters['temps'] != '') {
      filteredQuery = filteredQuery.where('temps', isEqualTo: filters['temps']);
    }

    List foundedOffres = [];

    QuerySnapshot snapshot = await filteredQuery.get();
    CollectionReference pharmaref = FirebaseFirestore.instance.collection('pharmacies');
    for (var data in snapshot.docs) {
      print("Document ID: ${data.id}");
      print("Data: ${data.data()}");
      print("-----------------------");
      var offreData = data.data() as Map<String, dynamic>?;
      var pharmacieId = offreData != null ? offreData['pharmacie_id'] : '';
      DocumentSnapshot pharmaDoc = await pharmaref.doc(pharmacieId).get();
      Map<String, dynamic> pharmaData =
          pharmaDoc.exists ? pharmaDoc.data() as Map<String, dynamic> : {};

      foundedOffres.add({'offre': data.data(), 'pharma_data': pharmaData});
    }
    return foundedOffres;
  }

  // Recherche des offres en fonctions des filtres de recherche
  Future<List> filterOffreToFindRecherches(filters) async {
    CollectionReference offres =
        FirebaseFirestore.instance.collection('recherches');
    Query filteredQuery = offres;
    print("----------FILTERS TITULAIRES-------------");
    print(filters);
    print("----------END---FILTERS-------------");

    // Recherche par contrat OK
    if (!filters['contrats'].contains('Intérimaire') &&
        filters['contrats'] != null &&
        filters['contrats'].isNotEmpty) {
      filteredQuery = filteredQuery.where('contrats',
          arrayContainsAny: filters['contrats']);
    }

    if (filters['poste'] != null) {
      filteredQuery = filteredQuery.where('poste', isEqualTo: filters['poste']);
    }

    if (filters['debut_contrat'] != '') {
      filteredQuery = filteredQuery.where('debut_contrat',
          isEqualTo: filters['debut_contrat']);
    }

    if (filters['debut_immediat'] != false) {
      filteredQuery = filteredQuery.where('debut_immediat',
          isEqualTo: filters['debut_immediat']);
    }

    if (filters['duree'] != '') {
      filteredQuery = filteredQuery.where('duree', isEqualTo: filters['duree']);
    }

    if (filters['grille_horaire'] != '') {
      filteredQuery = filteredQuery.where('grille_horaire',
          isEqualTo: filters['grille_horaire']);
    }

    if (filters['grille_horaire_impaire'] != '') {
      filteredQuery = filteredQuery.where('grille_horaire_impaire',
          isEqualTo: filters['grille_horaire_impaire']);
    }

    if (filters['grille_pair_impaire_identique'] != false) {
      filteredQuery = filteredQuery.where('grille_pair_impaire_identique',
          isEqualTo: filters['grille_pair_impaire_identique']);
    }

    if (filters['proposition_dispo_interim'] != null &&
        filters['proposition_dispo_interim'].isNotEmpty &&
        filters['contrats'].contains('Intérimaire')) {
      filteredQuery = filteredQuery.where('horaire_dispo_interim',
          arrayContainsAny: filters['horaire_dispo_interim']);
    }

    if (filters['salaire_mensuel'] != '') {
      filteredQuery = filteredQuery.where('salaire_mensuel',
          isEqualTo: filters['salaire_mensuel']);
    }

    if (filters['temps'] != '') {
      filteredQuery = filteredQuery.where('temps', isEqualTo: filters['temps']);
    }

    List foundedSearch = [];
    QuerySnapshot snapshot = await filteredQuery.get();

    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');
    for (var data in snapshot.docs) {
      print("Document ID: ${data.id}");
      print("Data: ${data.data()}");
      print("-----------------------");

      var rechercheData = data.data() as Map<String, dynamic>?;
      var userId = rechercheData != null ? rechercheData['user_id'] : '';
      DocumentSnapshot userDoc = await usersRef.doc(userId).get();
      Map<String, dynamic> userData =
          userDoc.exists ? userDoc.data() as Map<String, dynamic> : {};
      foundedSearch.add(userData);

      // foundedSearch.add(data.data());
    }
    return foundedSearch;
  }
}
