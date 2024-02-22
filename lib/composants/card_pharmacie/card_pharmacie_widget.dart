import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmabox/constant.dart';
import 'package:pharmabox/custom_code/widgets/pharmabox_logo.dart';
import 'package:pharmabox/discussion_user/discussion_user_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../custom_code/widgets/button_network_manager.dart';
import '../../custom_code/widgets/carousel_widget_pharma.dart';
import '../../custom_code/widgets/like_button.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'card_pharmacie_model.dart';
export 'card_pharmacie_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:like_button/like_button.dart';

class CardPharmacieWidget extends StatefulWidget {
  const CardPharmacieWidget({Key? key, this.data}) : super(key: key);

  final data;
  @override
  _CardPharmacieWidgetState createState() => _CardPharmacieWidgetState();
}

class _CardPharmacieWidgetState extends State<CardPharmacieWidget> {
  late CardPharmacieModel _model;
  Map<String, dynamic> _userData = {};

  Future<void> getUserById() async {
    try {
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(widget.data['user_id']);
      DocumentSnapshot userDoc = await userRef.get();
      if (userDoc.exists) {
        setState(() {
          _userData = userDoc.data() as Map<String, dynamic>;
        });
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CardPharmacieModel());
    getUserById();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 1.0,
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
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 1.0,
                height: 120.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ImageSliderWidget(
                  imageNames: widget.data['photo_url'],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => {
                context.pushNamed('PharmacieProfilView',
                    queryParameters: {
                      'pharmacieId': widget.data['documentId'],
                    })
              },
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: Text(
                        widget.data['situation_geographique']['adresse'].toString(),
                        overflow: TextOverflow.clip,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Poppins',
                              color: Color(0xFF161730),
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    if (widget.data['groupement'][0]['image'].toString() != 'Autre.jpg')
                      Container(
                        width: MediaQuery.of(context).size.width * 0.32,
                        child: Image.asset(
                          'assets/groupements/' + widget.data['groupement'][0]['image'].toString(),
                          width: 150.0,
                          height: 50.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (widget.data['groupement'][0]['image'].toString() == 'Autre.jpg')
                      Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          child: Row(
                            children: [
                              PharmaboxLogo(width: 35),
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(widget.data['groupement'][0]['name'].toString(), style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 12)),
                              ),
                            ],
                          ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 10.0, 15.0, 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFF595A71),
                        size: 35.0,
                      ),
                      if (widget.data['situation_geographique']['data']['country'] != null)
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              widget.data['situation_geographique']['data']['ville'].toString() + ', ' + widget.data['situation_geographique']['data']['country'].toString(),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF595A71),
                                  ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 1.0,
              decoration: BoxDecoration(
                color: Color(0xFFEFF6F7),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                  topLeft: Radius.circular(0.0),
                  topRight: Radius.circular(0.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: LikeButtonWidget(
                        documentId: widget.data['documentId'],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0x00FFFFFF),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF42D2FF), Color(0xFF7CEDAC)],
                                  stops: [0.0, 1.0],
                                  begin: AlignmentDirectional(1.0, 0.0),
                                  end: AlignmentDirectional(-1.0, 0),
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(2.0, 2.0, 2.0, 2.0),
                                child: FlutterFlowIconButton(
                                  borderColor: Color(0x0042D2FF),
                                  borderRadius: 30.0,
                                  borderWidth: 0.0,
                                  buttonSize: 40.0,
                                  fillColor: Colors.white,
                                  icon: Icon(
                                    Icons.phone,
                                    color: Color(0xFF42D2FF),
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    if (widget.data['contact_pharma']['preference_contact'] == 'Pharmacie') {
                                      await launch('tel:' + widget.data['contact_pharma']['telephone'].toString());
                                    } else {
                                      await launch('tel:' + _userData['telephone'].toString());
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF42D2FF), Color(0xFF7CEDAC)],
                                    stops: [0.0, 1.0],
                                    begin: AlignmentDirectional(1.0, 0.0),
                                    end: AlignmentDirectional(-1.0, 0),
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(2.0, 2.0, 2.0, 2.0),
                                  child: FlutterFlowIconButton(
                                    borderColor: Color(0x0042D2FF),
                                    borderRadius: 30.0,
                                    borderWidth: 0.0,
                                    buttonSize: 40.0,
                                    fillColor: Colors.white,
                                    icon: Icon(
                                      Icons.mail_outline_rounded,
                                      color: Color(0xFF42D2FF),
                                      size: 24.0,
                                    ),
                                    onPressed: () async {
                                      if (widget.data['contact_pharma']['preference_contact'] == 'Pharmacie') {
                                        await launch('mailto:' + widget.data['contact_pharma']['email'].toString());
                                      } else {
                                        await launch('mailto:' + _userData['email'].toString());
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF42D2FF), Color(0xFF7CEDAC)],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(1.0, 0.0),
                                end: AlignmentDirectional(-1.0, 0),
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(2.0, 2.0, 2.0, 2.0),
                              child: FlutterFlowIconButton(
                                borderColor: Color(0x0042D2FF),
                                borderRadius: 30.0,
                                borderWidth: 0.0,
                                buttonSize: 40.0,
                                fillColor: Colors.white,
                                icon: Icon(
                                  Icons.message_outlined,
                                  color: Color(0xFF42D2FF),
                                  size: 24.0,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DiscussionUserWidget(toUser: widget.data['user_id']),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
