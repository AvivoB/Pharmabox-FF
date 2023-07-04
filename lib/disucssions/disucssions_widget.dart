import '../constant.dart';
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
                context.pushNamed('Disucssions');
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 120.0,
              width: MediaQuery.of(context).size.width * 1.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4.0,
                    color: Color(0x33000000),
                    offset: Offset(0.0, 5.0),
                  )
                ]
              ),
              child: Row(
                children: [
                  Container(),
                  Column(
                    children: [
                      Text('Isabelle'),
                      Text('Pharmacien'),
                    ],
                  )
                ],
              ),
            ),
          ),
          ]
        ),
      )
    );
  }
}
