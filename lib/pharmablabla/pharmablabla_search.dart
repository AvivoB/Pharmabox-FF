import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pharmabox/backend/backend.dart';

import '../constant.dart';

class PharmaBlablaSearchData {
  // Recupere le nombre de commentaire pour chaque post
  Future<int> _getCommentsCount(String postId) async {
    final commentsSnapshot = await FirebaseFirestore.instance.collection('pharmablabla').doc(postId).collection('comments').get();
    return commentsSnapshot.docs.length;
  }

  // Recherche des offres en fonctions des filtres de recherche
  Future<List<Map<String, dynamic>>> filterPosts(String query) async {
    String searcher = query.toLowerCase();
    Query<Map<String, dynamic>> pharmablabla = FirebaseFirestore.instance.collection('pharmablabla').orderBy('date_created', descending: true);

    // Faire la requête pour les posts
    QuerySnapshot postResult = await pharmablabla.where('search_terms', arrayContains: searcher).get();

    List<Map<String, dynamic>> result = [];

    // Pour chaque post, faire une requête pour l'utilisateur associé
    await Future.wait(postResult.docs.map((postDoc) async {
      final userId = postDoc['userId'];
      final postId = postDoc.id;
      int commentsCount = await _getCommentsCount(postId);
      if (userId != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        if (userDoc.exists) {
          Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;
          postData['count_comment'] = commentsCount;
          result.add({
            'post': postData,
            'postId': postId,
            'user': userDoc.data(),
          });
        } else {}
      } else {}
    }));

    return result;
  }

  Future<List<Map<String, dynamic>>> getAllPosts() async {
      Query<Map<String, dynamic>> pharmablabla = FirebaseFirestore.instance.collection('pharmablabla').orderBy('date_created', descending: true);

      // Faire la requête pour les posts
      QuerySnapshot postResult = await pharmablabla.get();

      List<Map<String, dynamic>> result = [];

      // Pour chaque post, faire une requête pour l'utilisateur associé
      for (var postDoc in postResult.docs) {
        final userId = postDoc['userId'];
        final postId = postDoc.id;
        int commentsCount = await _getCommentsCount(postId);

        if (userId != null) {
          final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
          if (userDoc.exists) {
            Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;
            postData['count_comment'] = commentsCount.toString();
            result.add({
              'post': postData,
              'postId': postId,
              'user': userDoc.data(),
            });
          }
        }
      }

      return result;
  }

}
