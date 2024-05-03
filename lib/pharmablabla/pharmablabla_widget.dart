import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pharmabox/composants/card_pharmablabla/card_pharmablabla.dart';
import 'package:pharmabox/composants/card_user/card_user_widget.dart';
import 'package:pharmabox/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmabox/custom_code/widgets/progress_indicator.dart';
import 'package:pharmabox/pharma_job/pharmaJobSearchData.dart';
import 'package:pharmabox/pharmablabla/pharmablabla_model.dart';
import 'package:pharmabox/pharmablabla/pharmablabla_search.dart';

import '../composants/card_pharmacie/card_pharmacie_widget.dart';
import '../composants/card_pharmacie_offre_recherche/card_pharmacie_offre_recherche_widget.dart';
import '../custom_code/widgets/box_in_draggable_scroll.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../popups/popup_offre/popup_offre_widget.dart';
import '../popups/popup_recherche/popup_recherche_widget.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/composants/header_app/header_app_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart' hide LatLng;
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class PharmaBlabla extends StatefulWidget {
  const PharmaBlabla({Key? key, this.currentPage}) : super(key: key);
  final String? currentPage;

  @override
  _PharmaBlablaState createState() => _PharmaBlablaState();
}

class _PharmaBlablaState extends State<PharmaBlabla> {
  late PharmaBlablaModel _model;
  bool isTitulaire = false;
  bool _isLoading = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String? searchTerms;
  List searchResults = [];

  int itemsPerPage = 10; // Nombre d'éléments par page
  DocumentSnapshot? lastDocument;

  String? searchTerm; // Conservez une référence au dernier document chargé

  Map<String, dynamic> currentUser = {};

  void updateAllDocuments() async {
    // Get a reference to the collection
    final collection = FirebaseFirestore.instance.collection('pharmablabla');

    // Get all documents
    final documents = await collection.get();

    // Update each document
    for (final doc in documents.docs) {
      doc.reference.update({
        'users_viewed': FieldValue.arrayUnion([currentUserUid]),
      }).then((value) {
        // Update successful
      }).catchError((error) {
        print('Error updating document: $error');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PharmaBlablaModel());
    checkIsTitulaire().then((isTitulaire) {
      setState(() {
        this.isTitulaire = isTitulaire;
      });
    });
    getCurrentUserData().then((user_data) {
      setState(() {
        this.currentUser = user_data;
      });
    });

    updateAllDocuments();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Column(children: [
          wrapWithModel(
            model: _model.headerAppModel,
            updateCallback: () => setState(() {}),
            child: HeaderAppWidget(),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 1.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                controller: _model.searchPost,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Rechercher...',
                  hintStyle: FlutterFlowTheme.of(context).bodySmall,
                  contentPadding: EdgeInsets.all(15.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFD0D1DE),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(48.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFD0D1DE),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 24.0,
                    color: Color(0xFFD0D1DE),
                  ),
                ),
                style: FlutterFlowTheme.of(context).bodyMedium,
                // onChanged: (value) => getDataPost(query: value),
                onChanged: (value) async {
                  // await Future.delayed(Duration(milliseconds: 1000), () {
                  // });
                  setState(() {
                    searchTerm = value.toLowerCase(); // Mettez le terme de recherche en minuscules
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 15.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'PharmaBlabla',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4.0,
                        color: Color(0x33000000),
                        offset: Offset(0.0, 2.0),
                      )
                    ],
                    gradient: LinearGradient(
                      colors: [Color(0xFF7CEDAC), Color(0xFF42D2FF)],
                      stops: [0.0, 1.0],
                      begin: AlignmentDirectional(1.0, -1.0),
                      end: AlignmentDirectional(-1.0, 1.0),
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30.0,
                    borderWidth: 1.0,
                    buttonSize: 40.0,
                    icon: Icon(
                      Icons.send_outlined,
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      context.pushNamed('PharmaBlablaEditPost');
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('pharmablabla').orderBy('date_created', descending: true).get(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Erreur: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }

              final documents = snapshot.data!.docs;
              if (documents.isEmpty) {
                return Text('');
              }

              var filteredDocuments = documents.where((document) {
                final data = document.data() as Map<String, dynamic>;
                final title = data['post_content'] as String;

                // Comparez le titre avec le terme de recherche (en minuscules).
                return title.toLowerCase().contains(searchTerm ?? '');
              }).toList();

              // Filtrer les documents en fonction de mon réseau
              filteredDocuments = filteredDocuments.where((document) {
                final data = document.data() as Map<String, dynamic>;

                if (currentUser['id'] == data['userId']) {
                  return true;
                }

                if (data['network'] == 'Tout Pharmabox') {
                  return true;
                }

                if (currentUser['reseau'] != null && data['network'] == 'Mon réseau' && currentUser['reseau'].contains(data['userId'])) {
                  return true;
                }

                return false;
              }).toList();

              // Filtre sur les LGO
              filteredDocuments = filteredDocuments.where((document) {
                final data = document.data() as Map<String, dynamic>;
                //final names = currentUser['lgo'] != null ? currentUser['lgo'].map((item) => item['name']).toList() : [] ;

                if (currentUser['id'] == data['userId']) {
                  return true;
                }
                if (data['LGO'] == 'Par LGO' || !data.containsKey('LGO')) {
                  return true;
                }
                if (currentUser['lgo'] != null && currentUser['lgo'].map((item) => item['name']).toList().contains(data['LGO'])) {
                  return true;
                }

                return false;
              }).toList();

              // Filtre sur les postes visées
              filteredDocuments = filteredDocuments.where((document) {
                final data = document.data() as Map<String, dynamic>;

                if (currentUser['id'] == data['userId']) {
                  return true;
                }

                if (data['poste'] == null || !data.containsKey('poste')) {
                  return true;
                }

                if (data['poste'] != null && data['poste'].toString() == 'Tous') {
                  return true;
                }

                if (currentUser['poste'] != null && currentUser['poste'] == data['poste']) {
                  return true;
                }

                return false;
              }).toList();

              return ListView.builder(
                itemCount: filteredDocuments.length,
                itemBuilder: (BuildContext context, int index) {
                  final document = filteredDocuments[index];
                  final data = document.data() as Map<String, dynamic>;
                  final title = data['post_content'] as String;
                  final userId = data['userId'] as String;
                  data['post'] = document.data();
                  data['postId'] = document.id;

                  // print('PAGE '+widget.currentPage.toString());
                  // if (widget.currentPage.toString() == 'PharmaBlabla' ) {
                  // }

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }

                      if (userSnapshot.hasError) {
                        return Text('Erreur: ${userSnapshot.error}');
                      }

                      if (userSnapshot.hasData) {
                        final userData = userSnapshot.data?.data() != null ? userSnapshot.data?.data() as Map<String, dynamic> : null;
                        data['user'] = userData;

                        return FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance.collection('pharmablabla').doc(document.id).collection('comments').get(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> subSnapshot) {
                              if (subSnapshot.connectionState == ConnectionState.waiting) {
                                return Container();
                              }

                              if (subSnapshot.hasData) {
                                final numSubDocuments = subSnapshot.data!.docs.length;
                                data['post']['count_comment'] = numSubDocuments;

                                return Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                                  child: GestureDetector(
                                      child: userData != null ? CardPharmablabla(data: data) : Container(),
                                      onLongPress: () {
                                        if (currentUserUid == userId)
                                          showModalBottomSheet(
                                            context: context,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                                            ),
                                            builder: (BuildContext context) {
                                              return Container(
                                                height: MediaQuery.of(context).size.height * 0.60,
                                                // Contenu du BottomSheet
                                                child: Padding(
                                                  padding: const EdgeInsets.all(25.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        'Apporter des modifications',
                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                              fontFamily: 'Poppins',
                                                              fontSize: 18.0,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                      ),
                                                      ListTile(
                                                        title: Text('Modifier votre post'),
                                                        onTap: () {
                                                          // Action à effectuer lors du clic sur "Modifier"
                                                          Map postEdit = {'content': data['post_content'].toString(), 'postId': data['postId'].toString(), 'LGO': data['LGO'].toString(), 'network': data['network'].toString(), 'poste': data['poste'].toString()};
                                                          Navigator.pop(context);
                                                          context.pushNamed(
                                                            'PharmaBlablaEditPost',
                                                            queryParameters: {'content': data['post_content'].toString(), 'postId': data['postId'].toString(), 'LGO': data['LGO'].toString(), 'network': data['network'].toString(), 'poste': data['poste'].toString()},
                                                          );
                                                        },
                                                      ),
                                                      Divider(), // Ajoute une séparation entre les options
                                                      ListTile(
                                                        title: Text(
                                                          'Supprimer le post du Pharmablabla',
                                                          style: TextStyle(color: redColor), // Couleur rouge
                                                        ),
                                                        onTap: () async {
                                                          // Action à effectuer lors du clic sur "Supprimer"
                                                          Navigator.pop(context);
                                                          await FirebaseFirestore.instance.collection('pharmablabla').doc(data['postId'].toString()).delete();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                      },
                                      onTap: () {
                                        context.pushNamed(
                                          'PharmaBlablaSinglePost',
                                          queryParameters: {'postId': data['postId']},
                                        );
                                      }),
                                );
                              } else {
                                return Container();
                              }
                            });
                      } else {
                        return Container();
                      }
                    },
                  );
                },
              );
            },
          ))
        ]),
      ),
    );
  }
}
