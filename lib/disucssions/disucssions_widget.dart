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
  late CollectionReference<Map<String, dynamic>> messagesRef;

  TextEditingController _textEditingController = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DisucssionsModel());
    messagesRef = firestore.collection('messages');

    // Configurer la réception des notifications push
    messaging.getToken().then((token) {
      print('FCM Token: $token');
      messaging.subscribeToTopic('chat');
    });

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print('Notification reçue: ${message.notification!.title} - ${message.notification!.body}');
      }
    });
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
        title: Text(
          'Discussions',
            style: FlutterFlowTheme.of(context)
          .bodyMedium
          .override(
            fontFamily: 'Poppins',
            color: blackColor,
            fontSize: 20.0,
            fontWeight: FontWeight.w600
          )
        ),
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
              ]
            ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
           GestureDetector(
            onTap:() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DiscussionUserWidget(chatUser: 'dd', chatRef: 'hehe'),
                ),
              );
            },
             child: Padding(
                 padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 15.0, right: 15.0),
                 child: Container(
                   width: MediaQuery.of(context).size.width * 1.0,
                   // height: MediaQuery.of(context).size.height * 0.65,
                   decoration: BoxDecoration(
                     color: FlutterFlowTheme.of(context).secondaryBackground,
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
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                            child: Container(
                              width: 50.0,
                              height: 50.0,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: FadeInImage.assetNetwork(
                                image: 'photoUrl',
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
                                width: MediaQuery.of(context).size.width * 0.30,
                                child: Text(
                                  'nom' + ' ' + 'prenom',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: Color(0xFF595A71),
                                        fontSize: 15.0,
                                      ),
                                ),
                              ),
                              Container(
                                width: 135,
                                child: Text(
                                 'poste',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
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
                    Container(
                      decoration: BoxDecoration(
                                  color: redColor,
                                  shape: BoxShape.circle,
                                ),
                      child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 8.0, 8.0, 8.0),
                                  child: Text(
                                    '5',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          fontSize: 14.0,
                                        ),
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 15.0),
                child: Text(
                  'Salut comment ca va ...',
                  textAlign: TextAlign.left,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        color: Color(0xFF595A71),
                      ),
                ),
              ),
                     ],
                   ),
                 ),
               ),
           )
          ]
        ),
      )
    );
  }
}
