import 'package:cloud_firestore/cloud_firestore.dart';

import '../constant.dart';
import '/composants/card_pharmacie/card_pharmacie_widget.dart';
import '/composants/card_user/card_user_widget.dart';
import '/composants/header_app/header_app_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'reseau_model.dart';
export 'reseau_model.dart';

class ReseauWidget extends StatefulWidget {
  const ReseauWidget({Key? key}) : super(key: key);

  @override
  _ReseauWidgetState createState() => _ReseauWidgetState();
}

class _ReseauWidgetState extends State<ReseauWidget> {
  late ReseauModel _model;
  bool isExpanded_Titu = false;
  bool isExpanded_NonTitu = false;
  bool isExpanded_Pharma = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  List titulairesNetwork = [];
  List nonTitulairesNetwork = [];
  List pharmaciesNetwork = [];

  Future<void> getNetworkData() async {
    String currentUserId = await getCurrentUserId();

    // Use collection group to make query across all collections
    QuerySnapshot queryUsers = await FirebaseFirestore.instance.collection('users').where('reseau', arrayContains: currentUserId).get();

    QuerySnapshot queryPharmacies = await FirebaseFirestore.instance.collection('pharmacies').where('reseau', arrayContains: currentUserId).get();

    for (var doc in queryPharmacies?.docs ?? []) {
      var data = doc.data();
      data['documentId'] = doc.id;
      pharmaciesNetwork.add(data);
    }

    List fTitulaireNetwork = [];
    List fnonTitulairesNetwork = [];
    // Split users based on their 'poste' field
    for (var doc in queryUsers.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data != null && data['poste'] == 'Pharmacien(ne) titulaire') {
        fTitulaireNetwork.add(data);
      } else {
        fnonTitulairesNetwork.add(data);
      }
    }

    setState(() {
      titulairesNetwork = fTitulaireNetwork;
      nonTitulairesNetwork = fnonTitulairesNetwork;
    });
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReseauModel());
    getNetworkData();
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
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            wrapWithModel(
              model: _model.headerAppModel,
              updateCallback: () => setState(() {}),
              child: HeaderAppWidget(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Mon réseau',
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
                            // child: FlutterFlowIconButton(
                            //   borderColor: Colors.transparent,
                            //   borderRadius: 30.0,
                            //   borderWidth: 1.0,
                            //   buttonSize: 40.0,
                            //   icon: Icon(
                            //     Icons.add,
                            //     color: FlutterFlowTheme.of(context)
                            //         .secondaryBackground,
                            //     size: 20.0,
                            //   ),
                            //   onPressed: () {
                            //     print('IconButton pressed ...');
                            //   },
                            // ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                isExpanded_Titu = !isExpanded_Titu;
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 1.0,
                              height: 67,
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Color(0xFFF2FDFF), boxShadow: [BoxShadow(color: Color(0x2b1e5b67), blurRadius: 12, offset: Offset(10, 10))]),
                              child: Row(
                                children: [
                                  Icon(isExpanded_Titu ? Icons.expand_less : Icons.expand_more),
                                  Text(
                                    'Membres titulaires (' + titulairesNetwork.length.toString() + ')',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.0,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (isExpanded_Titu)
                            for (var i in titulairesNetwork) CardUserWidget(data: i),
                          SizedBox(height: 15),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isExpanded_NonTitu = !isExpanded_NonTitu;
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 1.0,
                              height: 67,
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Color(0xFFF2FDFF), boxShadow: [BoxShadow(color: Color(0x2b1e5b67), blurRadius: 12, offset: Offset(10, 10))]),
                              child: Row(
                                children: [
                                  Icon(isExpanded_NonTitu ? Icons.expand_less : Icons.expand_more),
                                  Text(
                                    'Membres (' + nonTitulairesNetwork.length.toString() + ')',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.0,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (isExpanded_NonTitu)
                            for (var i in nonTitulairesNetwork) CardUserWidget(data: i),
                          SizedBox(height: 15),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isExpanded_Pharma = !isExpanded_Pharma;
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 1.0,
                              height: 67,
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Color(0xFFF2FDFF), boxShadow: [BoxShadow(color: Color(0x2b1e5b67), blurRadius: 12, offset: Offset(10, 10))]),
                              child: Row(
                                children: [
                                  Icon(isExpanded_Pharma ? Icons.expand_less : Icons.expand_more),
                                  Text(
                                    'Pharmacies (' + pharmaciesNetwork.length.toString() + ')',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.0,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (isExpanded_Pharma)
                            for (var i in pharmaciesNetwork) CardPharmacieWidget(data: i),
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
