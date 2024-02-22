import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmabox/auth/firebase_auth/auth_util.dart';
import 'package:pharmabox/constant.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_theme.dart';
import '../../constant.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class ProfilDeleteAccount extends StatelessWidget {
  const ProfilDeleteAccount({Key? key});

  Future<void> deleteAccount() async {
    String currentUserId = await getCurrentUserId();

    print('MY ID :' + currentUserId.toString());
    try {
      // var headers = {
      //   'Content-Type': 'application/json',
      // };
      var request = http.Request('POST', Uri.parse('https://us-central1-pharmaff-dab40.cloudfunctions.net/deleteAccount'));
      request.bodyFields = {
        'userId': await getCurrentUserId()
      };
      // request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      }
      else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Erreur lors de l\'appel de la fonction: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: blackColor),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          'Supprimer mon compte',
          style: FlutterFlowTheme.of(context).titleSmall.override(
                fontFamily: 'Poppins',
                color: blackColor,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vous allez supprimer votre compte Pharmabox',
              style: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Poppins',
                    color: blackColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 15),
            Text(
              'Toutes les données suivantes seront supprimés :',
              style: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Poppins',
                    color: blackColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            SizedBox(height: 15),
            Text(
              '\u2022 Votre compte',
              style: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Poppins',
                    color: blackColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            SizedBox(height: 15),
            Text(
              '\u2022 Votre pharmacie si vous êtes titulaire',
              style: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Poppins',
                    color: blackColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            SizedBox(height: 15),
            Text(
              '\u2022 Vos messages',
              style: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Poppins',
                    color: blackColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            SizedBox(height: 15),
            Text(
              '\u2022 Votre réseau',
              style: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Poppins',
                    color: blackColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            SizedBox(height: 15),
            Text(
              '\u2022 Vos recherches et offres d\'emplois',
              style: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Poppins',
                    color: blackColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            SizedBox(height: 15),
            Text(
              '\u2022 Vos posts Pharmablabla',
              style: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Poppins',
                    color: blackColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            SizedBox(height: 15),
            Text(
              'Vous n\'apparaitrez plus dans les résultats de recherche ni dans le réseau Pharmabox, votre compte sera introuvable sur l\'application.',
              style: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Poppins',
                    color: blackColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            TextButton(
                onPressed: () async {
                  // GoRouter.of(context).prepareAuthEvent();
                  await deleteAccount();
                  await authManager.signOut();
                  GoRouter.of(context).clearRedirectLocation();
                  context.pushNamed('Register');
                },
                child: Text(
                  'Supprimer mon compte définitivement',
                  style: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Poppins',
                        color: redColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                ))
          ],
        ),
      ),
    );
  }
}
