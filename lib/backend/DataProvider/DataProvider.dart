import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmabox/constant.dart';
import 'package:http/http.dart' as http;


class DataProvider with ChangeNotifier {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fonction pour charger toutes les données nécessaires
  Future<void> fetchAllData() async {
    // // _isLoading = true;
    // notifyListeners();

    try {
      // Lancer plusieurs requêtes en parallèle
      List<Future> fetchTasks = [
        fetchAllPharmacies(),
        getLaboDB(),
        getNetworkData(),
        getPosts(),
      ];

      await Future.wait(fetchTasks); // Attend que toutes les requêtes soient terminées
    } catch (e) {
      print("Error loading data: $e");
    } finally {
      // _isLoading = false;
      notifyListeners();
    }
  }

// Charger les pharmacies
List _pharmacieInPlace = [];
List get pharmacieInPlace => _pharmacieInPlace;

Future<void> fetchAllPharmacies() async {
  try {
    // Récupérer l'ID utilisateur une seule fois pour éviter des appels répétés
    final String currentUserId = await getCurrentUserId();

    // Effectuer la requête Firestore
    QuerySnapshot querySnapshot = await _firestore
        .collection('pharmacies')
        .where('user_id', isNotEqualTo: currentUserId)
        .where('isValid', isEqualTo: true)
        .get();

    // Transformer les résultats
    final List<Map<String, dynamic>> fetchedPharmacies = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        ...data,
        'documentId': doc.id, // Ajouter l'ID du document
      };
    }).toList();

    // Ajouter les données à la liste locale
    _pharmacieInPlace.addAll(fetchedPharmacies);

    // Notifier une seule fois après l'ajout des données
    notifyListeners();
  } catch (e) {
    print("Error fetching Pharmacies: $e");
  }
}

  
// Charger les labos
List _laboDB = [];
List get getLabo => _laboDB;

Future<void> getLaboDB() async {
  final String url = 'https://script.google.com/macros/s/AKfycbxrqjg978ezEg4gI4lM_BPIWoS_bIay5cQItBBsBCG4AK22rE3qtcRsRiYAkiTrLT4uLw/exec';
  try {
      // Pas de données en cache, récupérer depuis l'API
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List fetchedData = json.decode(response.body);
          _laboDB = fetchedData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Erreur de chargement des données: ${response.statusCode}');
      }
    
  } catch (e) {
    print('Erreur: $e');
  }
}

// Récuperer les utilisateurs du réseau
List userNetwork = [];
List get getUserNetwork => userNetwork;
Future<void> getNetworkData() async {
  String currentUserId = await getCurrentUserId();

  // Use collection group to make query across all collections
  QuerySnapshot queryUsers = await FirebaseFirestore.instance.collection('users').where('reseau', arrayContains: currentUserId).get();

  List listUserNetwork = [];

  // Split users based on their 'poste' field
  for (var doc in queryUsers?.docs ?? []) {
    var data = doc.data();
    data['type'] = 'user';
    listUserNetwork.add(data);
  }
  userNetwork = listUserNetwork;
}


List _posts = [];
List get posts => _posts;

List _filteredPosts = [];
List get filteredPosts => _filteredPosts;

Future<void> getPosts() async {
  try {
    // Récupérer les 20 derniers posts triés par date
    final collection = FirebaseFirestore.instance
        .collection('pharmablabla')
        .orderBy('date_created', descending: true)
        .limit(20);

    final documents = await collection.get();

    // Lister les futures pour exécuter les requêtes en parallèle
    List<Future<Map<String, dynamic>>> postFutures = documents.docs.map((doc) async {
      final data = doc.data();
      final String postId = doc.id;

      // Lancer les requêtes en parallèle
      Future<int> commentsCountFuture = FirebaseFirestore.instance
          .collection('pharmablabla')
          .doc(postId)
          .collection('comments')
          .get()
          .then((comments) => comments.docs.length);

      Future<Map<String, dynamic>?> userDataFuture = FirebaseFirestore.instance
          .collection('users')
          .doc(data['userId'])
          .get()
          .then((userSnapshot) => userSnapshot.exists ? userSnapshot.data() : null);

      // Attendre les résultats des requêtes
      final results = await Future.wait([commentsCountFuture, userDataFuture]);

      // Construire les données mises à jour
      final updatedDocData = Map<String, dynamic>.from(data);
      updatedDocData['count_comment'] = results[0]; // Nombre de commentaires
      updatedDocData['postId'] = postId;           // ID du post
      if (results[1] != null) {
        updatedDocData['user'] = results[1];       // Données de l'utilisateur
      }

      return updatedDocData;
    }).toList();

    // Résoudre toutes les futures des posts
    final List<Map<String, dynamic>> updatedPosts = await Future.wait(postFutures);

    // Mettre à jour l'état avec les posts mis à jour
    _posts = updatedPosts;
    _filteredPosts = updatedPosts;

  } catch (e) {
    print("Error fetching posts: $e");
  }
}

}

