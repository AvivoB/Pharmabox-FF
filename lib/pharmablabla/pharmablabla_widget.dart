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
  const PharmaBlabla({Key? key}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PharmaBlablaModel());
    checkIsTitulaire().then((isTitulaire) {
      setState(() {
        this.isTitulaire = isTitulaire;
      });
    });
    getDataPost();
  }

  Future<void> getDataPost({query = ''}) async {
    if (query != '') {
      searchResults.clear();
      List<Map<String, dynamic>> posts =
          await PharmaBlablaSearchData().filterPosts(query);
      setState(() {
        searchResults = posts;
      });
    } else {
      searchResults.clear();
      setState(() {
        _isLoading = true;
      });
      List<Map<String, dynamic>> posts =
          await PharmaBlablaSearchData().getAllPosts();
      setState(() {
        searchResults = posts;
        _isLoading = false;
      });
    }
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
        child: Column(
          children: [
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
                  onChanged: (value) => getDataPost(query: value),
                ),
              ),
            ),
            Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 15.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'PharmaBlabla',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
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
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                size: 24.0,
                              ),
                              onPressed: () async {
                                context.pushNamed('PharmaBlablaAddPost');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            _isLoading ? Expanded(child: ProgressIndicatorPharmabox(background: Colors.transparent,)) : 
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    
                    
                    
                    for (var data in searchResults)
                    
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                            child: CardPharmablabla(data: data),
                            onTap: () {
                              context.pushNamed(
                                'PharmaBlablaSinglePost',
                                queryParams: {
                                  'postId': serializeParam(
                                    data['postId'],
                                    ParamType.String,
                                  ),
                                }.withoutNulls,
                              );
                            }),
                      )
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
