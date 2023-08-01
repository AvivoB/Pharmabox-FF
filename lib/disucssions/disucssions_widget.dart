import 'package:firebase_auth/firebase_auth.dart';

import '../constant.dart';
import '../custom_code/widgets/button_network_manager.dart';
import '../custom_code/widgets/like_button.dart';
import '../discussion_user/discussion_user_widget.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/chat/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'disucssions_model.dart';
export 'disucssions_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DisucssionsWidget extends StatefulWidget {
  const DisucssionsWidget({Key? key}) : super(key: key);

  @override
  _DisucssionsWidgetState createState() => _DisucssionsWidgetState();
}

class _DisucssionsWidgetState extends State<DisucssionsWidget> {
  late DisucssionsModel _model;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DisucssionsModel());
    getRecentConversations();
    // Configurer la réception des notifications push
  }

  Future<List> getRecentConversations() async {
    String currentId = await getCurrentUserId();

    // Récupérer les discussions avec le currentId en tant que receiverId
    final QuerySnapshot snapshot1 = await FirebaseFirestore.instance
        .collection('messages')
        .where('receiverId', isEqualTo: currentId)
        .orderBy('timestamp', descending: true)
        .get();

    // Récupérer les discussions avec le currentId en tant que fromId
    final QuerySnapshot snapshot2 = await FirebaseFirestore.instance
        .collection('messages')
        .where('fromId', isEqualTo: currentId)
        .orderBy('timestamp', descending: true)
        .get();

    final List conversations = [];
    // Map pour stocker les derniers messages de chaque conversation
    final Map<String, dynamic> lastMessages = {};

    // Parcourir les documents du snapshot1 pour trouver le dernier message de chaque conversation
    for (final DocumentSnapshot doc in snapshot1.docs) {
      final String conversationId = doc['receiverId'];
      final String message = doc['message'];

      // Vérifier si le dernier message de la conversation a déjà été enregistré
      if (lastMessages.containsKey(conversationId)) {
        // Si la conversation n'a pas encore de dernier message, l'ajouter
        lastMessages[conversationId] = {
          'message': message,
          'timestamp': doc['timestamp'],
        };
      }
    }

    // Parcourir les documents du snapshot2 pour trouver le dernier message de chaque conversation
    for (final DocumentSnapshot doc in snapshot2.docs) {
      final String conversationId = doc.id;
      final String message = doc['message'];

      // Vérifier si le dernier message de la conversation a déjà été enregistré
      if (lastMessages.containsKey(conversationId)) {
        // Si la conversation n'a pas encore de dernier message, l'ajouter
        lastMessages[conversationId] = {
          'message': message,
          'timestamp': doc['timestamp'],
        };
      }
    }

    // Convertir les derniers messages en une liste de maps
    final List recentConversations = lastMessages.values.toList();

    // Trier les conversations par ordre décroissant de timestamp
    recentConversations
        .sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

    print(recentConversations);

    return recentConversations;
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: greyLightColor,
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Discussions',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Poppins',
                  color: blackColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600)),
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4.0,
                      color: Color(0x33000000),
                      offset: Offset(0.0, 5.0),
                    )
                  ]),
              child: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 2.0,
                fillColor: Colors.white,
                icon: Icon(
                  Icons.chevron_left,
                  color: blackColor,
                  size: 24.0,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('messages').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                return Center(
                    child: Text('Aucune discussion récente',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Poppins',
                            color: blackColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600)));
              }

              // Filter the documents to include only those that contains the current user id
              List<DocumentSnapshot> userDocs =
                  snapshot.data!.docs.where((doc) {
                List<String> ids = doc.id.split('-');
                return ids.contains(currentUser?.uid);
              }).toList();

              return ListView.builder(
                  itemCount: userDocs.length,
                  itemBuilder: (BuildContext context, int index) {
                    String conversationId = userDocs[index].id;
                    // Split the conversation id to get the user id
                    List<String> userIds = conversationId.split('-');
                    // Find the user id that is not equal to the current user id
                    String otherUserId = userIds.firstWhere(
                      (id) => id != currentUser?.uid,
                      orElse: () => ''
                    );


                    DocumentSnapshot document = userDocs[index];
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('users').doc(otherUserId).get(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                         Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;

                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                                  .collection('messages')
                                  .doc(conversationId)
                                  .collection('message')
                                  .where('isViewed', isEqualTo: false)
                                  .snapshots(),
                          builder: (context, snapshot) {
                            int unreadMessagesCount = snapshot.data!.docs.length;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiscussionUserWidget(
                                        toUser: otherUserId),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5.0, bottom: 5.0, left: 15.0, right: 15.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 1.0,
                                  // height: MediaQuery.of(context).size.height * 0.65,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromRGBO(31, 92, 103, 0.17),
                                        offset: Offset(10.0, 10.0),
                                        blurRadius: 12.0,
                                        spreadRadius: -6.0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            15.0, 15.0, 15.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                // mainAxisAlignment: MainAxisAlignment.start,
                                                // crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional.fromSTEB(
                                                            0.0, 0.0, 10.0, 0.0),
                                                    child: Container(
                                                      width: 50.0,
                                                      height: 50.0,
                                                      clipBehavior: Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: FadeInImage.assetNetwork(
                                                        image: userData['photoUrl'],
                                                        placeholder:
                                                            'assets/images/Group_18.png',
                                                        fit: BoxFit.cover,
                                                        imageErrorBuilder: (context,
                                                            error, stackTrace) {
                                                          return Image.asset(
                                                              'assets/images/Group_18.png');
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.60,
                                                        child: Text(
                                                          userData['nom'] + ' ' + userData['prenom'],
                                                          style: FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: 'Poppins',
                                                                color:
                                                                    Color(0xFF595A71),
                                                                fontSize: 15.0,
                                                              ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 135,
                                                        child: Text(
                                                          userData['poste'],
                                                          style: FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily: 'Poppins',
                                                                color:
                                                                    Color(0xFF8D8D97),
                                                                fontSize: 13.0,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            unreadMessagesCount > 0 ?
                                            Container(
                                              decoration: BoxDecoration(
                                                color: redColor,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(
                                                    8.0, 8.0, 8.0, 8.0),
                                                child: Text(
                                                  unreadMessagesCount.toString(),
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            FlutterFlowTheme.of(context)
                                                                .primaryBackground,
                                                        fontSize: 14.0,
                                                      ),
                                                ),
                                              ),
                                            )
                                            :
                                            Container()
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            15.0, 15.0, 15.0, 15.0),
                                        child: Text(
                                          data['last_message'],
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Poppins',
                                                color: Color(0xFF595A71),
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        );
                      }
                    );
                  });
            }));
  }
}
