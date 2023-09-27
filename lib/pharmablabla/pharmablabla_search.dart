import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pharmabox/backend/backend.dart';

import '../constant.dart';

class PharmaBlablaSearchData {
  // Recherche des offres en fonctions des filtres de recherche
  Future<List<Map<String, dynamic>>> filterPosts(String query) async {
    String searcher = query.toLowerCase();
    CollectionReference pharmablabla = FirebaseFirestore.instance.collection('pharmablabla');

    // Faire la requête pour les posts
    QuerySnapshot postResult = await pharmablabla.where('search_terms', arrayContains: searcher).get();

    List<Map<String, dynamic>> result = [];

    // Pour chaque post, faire une requête pour l'utilisateur associé
    await Future.wait(postResult.docs.map((postDoc) async {
      final userId = postDoc['userId'];
      final postId = postDoc.id;
      if (userId != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        if (userDoc.exists) {
          result.add({
            'post': postDoc.data(),
            'postId': postId,
            'user': userDoc.data(),
          });
        } else {}
      } else {}
    }));

    return result;
  }

  Future<List<Map<String, dynamic>>> getAllPosts() async {
    CollectionReference pharmablabla = FirebaseFirestore.instance.collection('pharmablabla');

    // Faire la requête pour les posts
    QuerySnapshot postResult = await pharmablabla.get();

    List<Map<String, dynamic>> result = [];

    // Pour chaque post, faire une requête pour l'utilisateur associé
    await Future.wait(postResult.docs.map((postDoc) async {
      final userId = postDoc['userId'];
      final postId = postDoc.id;
      if (userId != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        if (userDoc.exists) {
          result.add({
            'post': postDoc.data(),
            'postId': postId,
            'user': userDoc.data(),
          });
        }
      }
    }));

    return result;
  }
}
