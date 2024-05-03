import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pharmabox/composants/card_pharmablabla/card_pharmablabla.dart';
import 'package:pharmabox/composants/card_user/card_user_widget.dart';
import 'package:pharmabox/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmabox/custom_code/widgets/like_button.dart';
import 'package:pharmabox/custom_code/widgets/progress_indicator.dart';
import 'package:pharmabox/pharma_job/pharmaJobSearchData.dart';
import 'package:pharmabox/pharmablabla/pharmablabla_model.dart';
import 'package:pharmabox/pharmablabla/pharmablabla_search.dart';

import '../composants/card_pharmacie/card_pharmacie_widget.dart';
import '../composants/card_pharmacie_offre_recherche/card_pharmacie_offre_recherche_widget.dart';
import '../custom_code/widgets/VideoPlayer.dart';
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

class PharmaBlablaSinglePost extends StatefulWidget {
  PharmaBlablaSinglePost({Key? key, required this.postId}) : super(key: key);

  String? postId;

  @override
  _PharmaBlablaSinglePostState createState() => _PharmaBlablaSinglePostState();
}

class _PharmaBlablaSinglePostState extends State<PharmaBlablaSinglePost> {
  late PharmaBlablaModel _model;
  bool _isLoading = false;
  final TextEditingController _commentMessage = TextEditingController();
  Map<String, dynamic> postAndUserData = {};

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String? searchTerms;

  Future<void> sendComments() async {
    final DocumentReference postDoc = FirebaseFirestore.instance.collection('pharmablabla').doc(widget.postId);
    String currentUserID = await getCurrentUserId();

    try {
      if (_commentMessage.text.isNotEmpty) {
        // Add a new document to the 'message' subcollection.
        await postDoc.collection('comments').add({
          'fromId': currentUserID,
          'message': _commentMessage.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        setState(() {
          _commentMessage.text = '';
        });
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Future<void> getPostAndUserData() async {
    setState(() {
      _isLoading = true;
    });
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      // Récupérer le document de la collection 'post'
      DocumentSnapshot postDoc = await _firestore.collection('pharmablabla').doc(widget.postId).get();

      if (!postDoc.exists) {
        throw Exception('Post not found!');
      }

      final postMap = postDoc.data() as Map<String, dynamic>;
      final userId = postMap['userId'];

      if (userId == null) {
        throw Exception('UserId is null!');
      }

      // Récupérer le document utilisateur correspondant
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        throw Exception('User not found!');
      }

      setState(() {
        postAndUserData = {
          'post': postMap,
          'user': userDoc.data() as Map<String, dynamic>,
        };
      });
    } catch (e) {
      rethrow;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PharmaBlablaModel());
    getPostAndUserData();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return ProgressIndicatorPharmabox();
    }

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Stack(
          children: [
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    wrapWithModel(
                      model: _model.headerAppModel,
                      updateCallback: () => setState(() {}),
                      child: HeaderAppWidget(),
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                                        child: Container(
                                          width: 50.0,
                                          height: 50.0,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: FadeInImage.assetNetwork(
                                            image: postAndUserData != null && postAndUserData['user']['photoUrl'] != null? postAndUserData['user']['photoUrl'] : '',
                                            placeholder: 'assets/images/Group_18.png',
                                            fit: BoxFit.cover,
                                            imageErrorBuilder: (context, error, stackTrace) {
                                              return Image.asset('assets/images/Group_18.png');
                                            },
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.5,
                                            child: Text(
                                              postAndUserData['user']['nom'] + ' ' + postAndUserData['user']['prenom'],
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 16.0, fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              postAndUserData['user']['poste'] ?? '',
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: 'Poppins',
                                                    color: Color(0xFF8D8D97),
                                                    fontSize: 13.0,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Text(DateFormat('dd/MM/yyyy à HH:mm', 'fr_FR').format(postAndUserData['post']['date_created'].toDate()), style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: Color(0xFF595A71), fontSize: 9.0)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(25.0, 10.0, 15.0, 15.0),
                            child: Text(
                              postAndUserData['post']['post_content'] ?? '',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: Color(0xFF595A71), fontSize: 15.0),
                            ),
                          ),
                        //   if(postAndUserData['post']['media'] != null)
                        Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(15.0, 10.0, 15.0, 10.0),
                            child: Container(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                child: Row(
                                  children: [
                                    for (final media in postAndUserData['post']['media'].toList())
                                      media.toString().contains('.mp4')
                                          ? Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(height: 200, child: VideoPlayerWidget(videoUrl: media)),
                                          )
                                          : Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(height: 200, child: Image.network(media)),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('pharmablabla').doc(widget.postId).collection('comments').orderBy('timestamp', descending: true).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text('Une erreur s\'est produite'));
                          }
                    
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container();
                          }
                    
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Center(
                                  child: Text(
                                'Commentez en premier ce post.',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 14.0, fontWeight: FontWeight.w600),
                              )),
                            );
                          }
                    
                          final mergedList = snapshot.data!.docs;
                    
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: ListView(
                              reverse: true,
                              padding: EdgeInsets.only(right: 12.0, left: 12.0, bottom: 150),
                              children: mergedList.map((doc) {
                                bool isCurrentUser = doc['fromId'] == currentUser?.uid;
                                              
                                return FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance.collection('users').doc(doc['fromId']).get(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(child: CircularProgressIndicator()); // Montrez un loader pendant que les données de l'utilisateur sont récupérées
                                      }
                                              
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Container();
                                      }
                                              
                                      if (snapshot.hasError) {
                                        return Center(child: Text('Une erreur s\'est produite'));
                                      }
                                              
                                      Map<String, dynamic>? userData = snapshot.data!.data() as Map<String, dynamic>?; // Cast en toute sécurité
                                      return Container(
                                        padding: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
                                        child: Align(
                                          alignment: (isCurrentUser ? Alignment.topRight : Alignment.topLeft),
                                          child: Column(
                                            crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(
                                                  maxWidth: MediaQuery.of(context).size.width * 0.8, // Ajustez la valeur selon vos besoins
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: (Colors.grey.shade200),
                                                ),
                                                padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                                                child: Column(
                                                  crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                                  children: [
                                                    if (!isCurrentUser)
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                                                            child: Container(
                                                              width: 20.0,
                                                              height: 20.0,
                                                              clipBehavior: Clip.antiAlias,
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                              ),
                                                              child: FadeInImage.assetNetwork(
                                                                image: userData != null ? userData['photoUrl'] : '',
                                                                placeholder: 'assets/images/Group_18.png',
                                                                fit: BoxFit.cover,
                                                                imageErrorBuilder: (context, error, stackTrace) {
                                                                  return Image.asset('assets/images/Group_18.png');
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          Text(userData != null ? userData['nom'] + ' ' + userData['prenom'] : 'Utilisateur', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 12.0, fontWeight: FontWeight.w600)),
                                                        ],
                                                      ),
                                                    if (isCurrentUser) Text('Vous', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 12.0, fontWeight: FontWeight.w600)),
                                                    SizedBox(height: 10),
                                                    Text(doc['message'], style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 14, fontWeight: FontWeight.w400)),
                                                    SizedBox(height: 10),
                                                    if (!isCurrentUser)
                                                      Container(
                                                        child: Row(
                                                          mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                                                          children: [
                                                            Text(DateFormat('dd/MM/yyyy à HH:mm', 'fr_FR').format(doc['timestamp']?.toDate()), style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: Color(0xFF595A71), fontSize: 9.0)),
                                                            SizedBox(width: 10),
                                                            LikeButtonWidget(
                                                              documentId: doc.id,
                                                              size: 10,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    if (isCurrentUser)
                                                      Container(
                                                        width: 250,
                                                        child: Row(
                                                          mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                                                          children: [
                                                            LikeButtonWidget(
                                                              documentId: doc.id,
                                                              size: 10,
                                                            ),
                                                            SizedBox(width: 10),
                                                            Text(DateFormat('dd/MM/yyyy à HH:mm', 'fr_FR').format(doc['timestamp'].toDate()), style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: Color(0xFF595A71), fontSize: 9.0)),
                                                          ],
                                                        ),
                                                      )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              left: 0,
              child: 
              Container(
                width: 500,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    color: Colors.white),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: _commentMessage,
                        minLines: 1,
                        maxLines: null,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Votre commentaire',
                          hintStyle: FlutterFlowTheme.of(context).bodySmall,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFD0D1DE),
                              width: 1.0,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).focusColor,
                              width: 1.0,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium,
                        // Add done button to keyboard
                        textInputAction: TextInputAction.go,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    ClipOval(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              blueColor,
                              greenColor,
                            ],
                          ),
                        ),
                        child: Material(
                          elevation: 0,
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              sendComments();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: SvgPicture.asset(
                                'assets/icons/Message.svg',
                                color: Colors.white,
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
