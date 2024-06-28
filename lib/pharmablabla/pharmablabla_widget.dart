import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:pharmabox/composants/card_pharmablabla/card_pharmablabla.dart';
import 'package:pharmabox/composants/card_user/card_user_widget.dart';
import 'package:pharmabox/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmabox/custom_code/widgets/pharmabox_logo.dart';
import 'package:pharmabox/custom_code/widgets/progress_indicator.dart';
import 'package:pharmabox/pharma_job/pharmaJobSearchData.dart';
import 'package:pharmabox/pharmablabla/pharmablabla_model.dart';
import 'package:pharmabox/pharmablabla/pharmablabla_search.dart';
import 'package:pharmabox/popups/popup_themes_pharmablabla/popup_theme_pharmablabla_widget.dart';

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
  List posts = [];
  List filteredPosts = [];

  bool displaySearch = true;
  bool displayFilter = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String? searchTerms;

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

  void getPosts() async {
    setState(() {
      _isLoading = true;
    });
    // Get a reference to the collection
    final collection = FirebaseFirestore.instance.collection('pharmablabla').orderBy('date_created', descending: true);

    // Get all documents
    final documents = await collection.get();

    // List to store updated posts
    List<Map<String, dynamic>> updatedPosts = [];

    // Process each document
    for (final doc in documents.docs) {
      // Get comments count
      final comments = await FirebaseFirestore.instance.collection('pharmablabla').doc(doc.id).collection('comments').get();
      final commentsCount = comments.docs.length;

      // Get user data
      final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(doc.data()['userId']).get();
      Map<String, dynamic>? userData;
      if (userSnapshot.exists) {
        userData = userSnapshot.data();
      }

      // Create a new map with updated data
      final updatedDocData = Map<String, dynamic>.from(doc.data());
      updatedDocData['count_comment'] = commentsCount;
      updatedDocData['postId'] = doc.id;
      if (userData != null) {
        updatedDocData['user'] = userData;
      }

      // Add updated data to the list
      updatedPosts.add(updatedDocData);
    }

    // Update the state with the modified list of posts
    setState(() {
      posts = updatedPosts;
      filteredPosts = posts;
      _isLoading = false;
    });
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
    getPosts();
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
        child: _isLoading
            ? ProgressIndicatorPharmabox()
            : Column(children: [
                wrapWithModel(
                  model: _model.headerAppModel,
                  updateCallback: () => setState(() {}),
                  child: HeaderAppWidget(),
                ),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.84,
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
                            if (value.isEmpty) {
                              setState(() {
                                filteredPosts = posts;
                              });
                            }
                            if (value.length > 3) {
                              setState(() {
                                filteredPosts = posts.where((post) => post['post_content'].toString().toLowerCase().contains(value.toLowerCase())).toList();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.16,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
                        child: Container(
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
                              Icons.add_comment_rounded,
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              size: 24.0,
                            ),
                            onPressed: () async {
                              context.pushNamed('PharmaBlablaEditPost');
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      height: 50,
                      child: TextButton(
                          onPressed: () {
                            if (_model.reseauType == 'Tout Pharmabox' && currentUser['reseau'] != null) {
                              setState(() {
                                _model.reseauType = 'Mon réseau';
                                // Filter posts where user_id is present in my network
                                var postMyNetwork = posts.where((post) => currentUser['reseau'].contains(post['userId']) && post['user']['reseau'].contains(currentUser['id'])).toList();
                                var filteredAndSkippedPosts = postMyNetwork.skip(1).toList();
                                filteredPosts = filteredAndSkippedPosts;
                              });
                            } else {
                              setState(() {
                                _model.reseauType = 'Tout Pharmabox';
                                filteredPosts = posts;
                              });
                            }
                          },
                          child: Row(
                            children: [
                              _model.reseauType == 'Tout Pharmabox'
                                  ? PharmaboxLogo(width: 25)
                                  : Icon(
                                      Icons.group_outlined,
                                      color: greyColor,
                                    ),
                              SizedBox(width: 5),
                              Text(_model.reseauType, style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: Colors.black, fontSize: 11)),
                            ],
                          )),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      height: 50,
                      child: TextButton(
                          onPressed: () async {
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              enableDrag: false,
                              context: context,
                              builder: (bottomSheetContext) {
                                return DraggableScrollableSheet(
                                    initialChildSize: 0.75,
                                    builder: (BuildContext context, ScrollController scrollController) {
                                      return GestureDetector(
                                        onTap: () => '',
                                        child: Padding(
                                          padding: MediaQuery.of(bottomSheetContext).viewInsets,
                                          child: PopupThemePharmablablaWidget(
                                            onTap: (theme) {
                                              // var postst = posts.where((post) => post['theme'].toString() == theme).toList();
                                              setState(() {
                                                _model.selectedTheme = theme;
                                                List filteredPosts2 = [];
                                                posts.forEach((element) {
                                                  if (element['theme'].toString().trim().toLowerCase() == theme.trim().toLowerCase()) {
                                                    print('post theme :' + element['theme'].toString() + ' - selected theme :' + theme);
                                                    filteredPosts2.add(element);
                                                  }
                                                });
                                                filteredPosts = filteredPosts2;
                                              });
                                            },
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ).then((value) => setState(() {}));
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.filter_list,
                                color: greyColor,
                              ),
                              SizedBox(width: 5),
                              Flexible(child: Container(child: Text(_model.selectedTheme, overflow: TextOverflow.ellipsis, style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: Colors.black, fontSize: 11)))),
                            ],
                          )),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      height: 50,
                      child: TextButton(
                          onPressed: () async {
                            setState(() {
                              filteredPosts = posts;
                              _model.selectedTheme = 'Thème de discussion';
                            });
                          },
                          child: Icon(
                            Icons.change_circle_outlined,
                            color: greyColor,
                          )),
                    ),
                  ],
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: filteredPosts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final document = filteredPosts[index];
                    // final data = document.data() as Map<String, dynamic>;
                    final title = document['post_content'] as String;
                    final userId = document['userId'] as String;
                    // data['post'] = document.data();
                    // document['postId'] = document.id;


                    return Padding(
                      padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 2.0, bottom: 2.0),
                      child: GestureDetector(
                          child: document['user'] != null ? CardPharmablabla(data: document) : Container(),
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
                                              Map postEdit = {'content': document['post_content'].toString(), 'postId': document['postId'].toString(), 'theme': document['theme'].toString(), 'network': document['network'].toString(), 'poste': document['poste'].toString()};
                                              Navigator.pop(context);
                                              context.pushNamed(
                                                'PharmaBlablaEditPost',
                                                queryParameters: {'content': document['post_content'].toString(), 'postId': document['postId'].toString(), 'theme': document['theme'].toString(), 'network': document['network'].toString(), 'poste': document['poste'].toString()},
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
                                              await FirebaseFirestore.instance.collection('pharmablabla').doc(document['postId'].toString()).delete();
                                              setState(() {
                                                posts.removeAt(index);
                                              });
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
                              queryParameters: {'postId': document['postId']},
                            );
                          }),
                    );
                  },
                ))
              ]),
      ),
    );
  }
}
