import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pharmabox/auth/base_auth_user_provider.dart';

import '../constant.dart';

class PharmaJobSearchData {
  // Recherche des offres en fonctions des filtres de recherche
  Future<List> filterRechercheToFindOffre(filters) async {
    CollectionReference offres = FirebaseFirestore.instance.collection('offres');
    Query filteredQuery = offres;
    print("----------FILTERS NORMAL-------------");
    print(filters);
    print("----------END---FILTERS-------------");

    // Recherche par contrat OK
    if (!filters['contrats'].contains('Intérimaire') && filters['contrats'] != null && filters['contrats'].isNotEmpty) {
      filteredQuery = filteredQuery.where('contrats', arrayContainsAny: filters['contrats']);
    }

    if (filters['debut_contrat'] != '') {
      filteredQuery = filteredQuery.where('debut_contrat', isEqualTo: filters['debut_contrat']);
    }

    if (filters['debut_immediat'] != false) {
      filteredQuery = filteredQuery.where('debut_immediat', isEqualTo: filters['debut_immediat']);
    }

    if (filters['horaire_dispo_interim'] != null && filters['horaire_dispo_interim'].isNotEmpty && filters['contrats'].contains('Intérimaire')) {
      filteredQuery = filteredQuery.where('proposition_dispo_interim', arrayContainsAny: filters['horaire_dispo_interim']);
    }

    if (filters['temps'] != '') {
      filteredQuery = filteredQuery.where('temps', isEqualTo: filters['temps']);
    }

    List foundedOffres = [];

    QuerySnapshot snapshot = await filteredQuery.get();
    CollectionReference pharmaref = FirebaseFirestore.instance.collection('pharmacies');
    for (var data in snapshot.docs) {
      var offreData = data.data() as Map<String, dynamic>?;
      var pharmacieId = offreData != null ? offreData['pharmacie_id'] : '';
      DocumentSnapshot pharmaDoc = await pharmaref.doc(pharmacieId).get();
      Map<String, dynamic> pharmaData = pharmaDoc.exists ? pharmaDoc.data() as Map<String, dynamic> : {};

      DocumentSnapshot userRef = await FirebaseFirestore.instance.collection('users').doc(pharmaData['user_id']).get();
      Map<String, dynamic> userData = userRef.exists ? pharmaDoc.data() as Map<String, dynamic> : {};

      foundedOffres.add({'offre': data.data(), 'offer_id': data.id, 'pharma_data': pharmaData, 'pharma_id': pharmacieId, 'user_data': userData});
    }
    return foundedOffres;
  }

  // Recherche des membres en fonctions des filtres de recherche de profil
  Future<List> filterOffreToFindRecherches(filters) async {
    CollectionReference offres = FirebaseFirestore.instance.collection('recherches');
    Query filteredQuery = offres;
    print("----------FILTERS TITULAIRES-------------");
    print(filters);
    print("----------END---FILTERS-------------");

    // Recherche par contrat OK
    if (!filters['contrats'].contains('Intérimaire') && filters['contrats'] != null && filters['contrats'].isNotEmpty) {
      filteredQuery = filteredQuery.where('contrats', arrayContainsAny: filters['contrats']);
    }

    if (filters['poste'] != null) {
      filteredQuery = filteredQuery.where('poste', isEqualTo: filters['poste']);
    }

    if (filters['debut_contrat'] != '') {
      filteredQuery = filteredQuery.where('debut_contrat', isEqualTo: filters['debut_contrat']);
    }

    if (filters['debut_immediat'] != false) {
      filteredQuery = filteredQuery.where('debut_immediat', isEqualTo: filters['debut_immediat']);
    }

    if (filters['proposition_dispo_interim'] != null && filters['proposition_dispo_interim'].isNotEmpty && filters['contrats'].contains('Intérimaire')) {
      filteredQuery = filteredQuery.where('horaire_dispo_interim', arrayContainsAny: filters['horaire_dispo_interim']);
    }

    if (filters['temps'] != '') {
      filteredQuery = filteredQuery.where('temps', isEqualTo: filters['temps']);
    }

    List foundedSearch = [];
    QuerySnapshot snapshot = await filteredQuery.get();

    Set<String> uniqueUserIds = {}; // Pour stocker les userId uniques
    Set<Map<String, dynamic>> uniqueSearch = {}; // Pour stocker les userData uniques

    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
    for (var data in snapshot.docs) {
      print("Document ID: ${data.id}");
      print("Data: ${data.data()}");
      print("-----------------------");

      var rechercheData = data.data() as Map<String, dynamic>?;
      var userId = rechercheData != null ? rechercheData['user_id'] : '';

      if (!uniqueUserIds.contains(userId)) {
        // Si l'userId n'a pas encore été traité
        DocumentSnapshot userDoc = await usersRef.doc(userId).get();
        Map<String, dynamic> userData = userDoc.exists ? userDoc.data() as Map<String, dynamic> : {};

        uniqueSearch.add(userData); // Les Sets n'ajouteront pas de doublons
        uniqueUserIds.add(userId); // Ajouter l'userId au Set
      }
    }
    return uniqueSearch.toList();
  }

  Future<List> getMesRecherches() async {
    String currenuserID = await getCurrentUserId();
    bool isTitu = await checkIsTitulaire();
    List mySearch = [];
    print('CURR USER step' + isTitu.toString());
    mySearch.clear();
    CollectionReference recherches = FirebaseFirestore.instance.collection(isTitu ? 'offres' : 'recherches');
    Query queryRecherche = recherches;

    queryRecherche.where('user_id', isEqualTo: currenuserID);
    QuerySnapshot snapshot = await queryRecherche.get();

    for (var search in snapshot.docs) {
      Map<String, dynamic> data = search.data() as Map<String, dynamic>;
      if (data['user_id'] == currenuserID) {
        mySearch.add(data);
        print('USER8ID' + data['user_id'].toString());
        print(data['user_id']);
      }
    }

    return mySearch.toList();
  }
}
