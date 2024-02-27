import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pharmabox/auth/base_auth_user_provider.dart';

import '../constant.dart';

class PharmaJobSearchData {
  // Recherche des offres en fonctions des filtres de recherche
  Future<List> filterRechercheToFindOffre(filters) async {
    Map<String, dynamic> userData = await getCurrentUserData();

    CollectionReference offres = FirebaseFirestore.instance.collection('offres');
    Query filteredQuery = offres;
    print("----------FILTERS NORMAL-------------");
    print(filters);
    print("----------END---FILTERS-------------");

    filteredQuery = filteredQuery.where('poste', isEqualTo: userData['poste']);

    filteredQuery = filteredQuery.where('isActive', isEqualTo: true);

    print("----------" + userData['poste'] + "-------------");

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
      filteredQuery = filteredQuery.where('proposition_dispo_interim', arrayContainsAny: filters['horaire_dispo_interim']).where('contrats', arrayContainsAny: filters['contrats']);
    }

    if (filters['temps'] != '') {
      filteredQuery = filteredQuery.where('temps', isEqualTo: filters['temps']);
    }

    String cityJob = '';

    filters['localisation'] != null ? cityJob = extractCityFromLocation(filters['localisation']) : '';

    Map<String, dynamic> cityCoordinates = await getCityCoordinates(cityJob);
    var cityLatitude = cityCoordinates['latitude'];
    var cityLongitude = cityCoordinates['longitude'];

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

      if (cityJob != '' && cityJob == pharmaData['situation_geographique']['data']['ville'] && filters['rayon'] == '') {
        foundedOffres.add({'offre': data.data(), 'offer_id': data.id, 'pharma_data': pharmaData, 'pharma_id': pharmacieId, 'user_data': userData});
      }
      if (cityJob == '') {
        foundedOffres.add({'offre': data.data(), 'offer_id': data.id, 'pharma_data': pharmaData, 'pharma_id': pharmacieId, 'user_data': userData});
      }

      if (cityJob != '' && filters['rayon'] != '') {
        // Calculate the distance using Haversine formula
        double distance = calculateHaversineDistance(cityLatitude, cityLongitude, pharmaData['situation_geographique']['data']['latitude'], pharmaData['situation_geographique']['data']['longitude']);
        print('DISTANCE : ' + distance.toString());
        if (distance <= double.parse(filters['rayon'])) {
          foundedOffres.add({'offre': data.data(), 'offer_id': data.id, 'pharma_data': pharmaData, 'pharma_id': pharmacieId, 'user_data': userData});
        }
      }
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

    filteredQuery = filteredQuery.where('isActive', isEqualTo: true);

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
      // Cherche les offres qui ont les horaires de disponibilité de l'intérim et des dates de dispo contenu dans la proposition_dispo_interim
       
      filteredQuery = filteredQuery.where('contrats', arrayContainsAny: filters['contrats']).where('horaire_dispo_interim', arrayContains: filters['proposition_dispo_interim']);
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

        if (userData['nom'] != null && userData['prenom'] != null) {
          uniqueSearch.add(userData); // Les Sets n'ajouteront pas de doublons
          uniqueUserIds.add(userId); // Ajouter l'userId au Set
        }
      }
    }
    return uniqueSearch.toList();
  }

  Future<List> getMesRecherches() async {
    String currenuserID = await getCurrentUserId();
    bool isTitu = await checkIsTitulaire();
    List mySearch = [];

    mySearch.clear();
    CollectionReference recherches = FirebaseFirestore.instance.collection(isTitu ? 'offres' : 'recherches');
    Query queryRecherche = recherches;

    queryRecherche = queryRecherche.where('user_id', isEqualTo: currenuserID);
    queryRecherche = queryRecherche.where('isActive', isEqualTo: true);

    QuerySnapshot snapshot = await queryRecherche.get();

    for (var search in snapshot.docs) {
      Map<String, dynamic> data = search.data() as Map<String, dynamic>;
      data['doc_id'] = search.id;
      if (data['user_id'] == currenuserID) {
        mySearch.add(data);

        print('SAVED SEARCHS ' + mySearch.toString());
      }
    }

    return mySearch.toList();
  }
}

String extractCityFromLocation(String locationString) {
  // Diviser la chaîne en fonction de la virgule et obtenir le premier élément
  List<String> parts = locationString.split(',');

  // Récupérer la première partie (la ville)
  String city = parts.isNotEmpty ? parts[0].trim() : '';

  return city;
}

Future<Map<String, dynamic>> getCityCoordinates(String cityName) async {
  // Replace 'YOUR_API_KEY' with your actual Google Maps API key
  String apiUrl = 'https://maps.googleapis.com/maps/api/geocode/json?address=$cityName&key=$googleMapsApi';

  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    if (data['status'] == 'OK' && data['results'].isNotEmpty) {
      final location = data['results'][0]['geometry']['location'];
      double latitude = location['lat'];
      double longitude = location['lng'];
      return {'latitude': latitude, 'longitude': longitude};
    }
  }

  return {'latitude': 0.0, 'longitude': 0.0};
}

double calculateHaversineDistance(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371.0; // Earth radius in kilometers

  double dLat = (lat2.toDouble() - lat1.toDouble()) * (pi / 180.0);
  double dLon = (lon2.toDouble() - lon1.toDouble()) * (pi / 180.0);

  double a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1.toDouble() * (pi / 180.0)) * cos(lat2.toDouble() * (pi / 180.0)) * sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return R * c; // Distance in kilometers
}
