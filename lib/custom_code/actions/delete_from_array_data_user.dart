// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:firebase_auth/firebase_auth.dart';

Future deleteFromArrayDataUser(
  String arrayname,
  int itemid,
) async {
  // Add your function code here!

  final id = itemid.toString();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? uid = await FirebaseAuth.instance.currentUser?.uid;
  final DocumentReference documentReference =
      _firestore.collection("users").doc(uid);
  final DocumentSnapshot documentSnapshot =
      await documentReference.get().catchError((e) {
    print(e.toString());
  });
  if (documentSnapshot.exists) {
    documentReference.update({
      arrayname + '.' + id: FieldValue.delete(),
    }).catchError((e) {
      print(e.toString());
    });
  }
}
