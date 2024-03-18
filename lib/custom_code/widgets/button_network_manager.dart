// Automatic FlutterFlow imports
import 'package:pharmabox/constant.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:simple_gradient_text/simple_gradient_text.dart';

class ButtonNetworkManager extends StatefulWidget {
  ButtonNetworkManager({
    Key? key,
    this.width,
    this.height,
    required this.text,
    required this.radius,
    required this.fontSize,
    required this.typeCollection,
    required this.docId,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String text;
  final String typeCollection;
  final String docId;
  final double radius;
  final double fontSize;

  @override
  _ButtonNetworkManagerState createState() => _ButtonNetworkManagerState();
}

class _ButtonNetworkManagerState extends State<ButtonNetworkManager> {
  bool isInNetwork = false;
  String messageButton = 'Ajouter';
  bool isCurrentUser = false;

  // Ajoute au réseau
  Future<void> addToNetwork() async {
    String currentUserId = await getCurrentUserId();

    final demandesRef = FirebaseFirestore.instance.collection('demandes_network');
    final demandesData = {
      'by_user': currentUserId,
      'status': 'pending',
      'for': widget.docId,
      'timestamp': FieldValue.serverTimestamp(),
    };
    await demandesRef.add(demandesData);
    print('Envoyé demande');
    setState(() {
      messageButton = 'Envoyée';
    });
  }

// Supprime du réseau
  Future<void> deleteNetwork(String typeCollection, String docId) async {
    String currentuserid = await getCurrentUserId();

    final documentRef = FirebaseFirestore.instance
        .collection(typeCollection) // replace with your collection name
        .doc(docId);

    final currentUserRef = FirebaseFirestore.instance
        .collection('users') // replace with your collection name
        .doc(currentuserid);

    await documentRef.update({
      'reseau': FieldValue.arrayRemove([currentuserid]),
    });
    await currentUserRef.update({
      'reseau': FieldValue.arrayRemove([docId]),
    });
    setState(() {
      isInNetwork = false;
      messageButton = 'Ajouter';
    });
  }

// Verifie si on est dans le réseau
  Future<void> verifyInNetwork(String typeCollection, String docId) async {
    String currentUserId = await getCurrentUserId();

    isCurrentUser = docId == currentUserId ? true : false;

    QuerySnapshot demandesSnapshot = await FirebaseFirestore.instance.collection('demandes_network').where('for', isEqualTo: docId).where('by_user', isEqualTo: currentUserId).get();

    if (demandesSnapshot.docs.isNotEmpty) {
      // If there is a request in the 'demandes_network' collection, set isInNetwork to 'demande envoyée'
      setState(() {
        isInNetwork = false;
        messageButton = 'Envoyée';
      });
    } else {
      DocumentReference documentRef = FirebaseFirestore.instance
          .collection(typeCollection) // replace with your collection name
          .doc(docId);

      DocumentSnapshot documentSnapshot = await documentRef.get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

        // Check if 'reseau' array contains the current user's ID
        if (data['reseau'] != null? data['reseau'].contains(currentUserId) : false) {
          // If the current user's ID is found in the 'reseau' array, remove it
          setState(() {
            isInNetwork = true;
            messageButton = '';
          });
        } else {
          // If the document snapshot does not exist, set isInNetwork to 'ajouter'
          setState(() {
            isInNetwork = false;
            messageButton = 'Ajouter';
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    verifyInNetwork(widget.typeCollection, widget.docId);
  }

  @override
  Widget build(BuildContext context) {
    if (isInNetwork && !isCurrentUser) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: redColor,
          ),
          iconSize: 26,
          onPressed: () async {
            await deleteNetwork(widget.typeCollection, widget.docId);
            setState(() {});
          },
        ),
      );
    }
    if (!isInNetwork && !isCurrentUser) {
      return Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: GestureDetector(
            onTap: () async {
              if (messageButton != 'Envoyée') {
                await addToNetwork();
              }
            },
            child: GradientText(
              messageButton,
              radius: this.
              
              widget.radius,
              style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', fontSize: 14.0, fontWeight: FontWeight.w400),
              colors: [Color(0xff7CEDAC), Color(0xFF42D2FF)],
            ),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 2.0,
            ),
          ],
        ),
      );
    }

    return Container();
  }
}
