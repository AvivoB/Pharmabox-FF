import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pharmabox/composants/card_user/card_user_widget.dart';
import 'package:pharmabox/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmabox/custom_code/widgets/pharmabox_logo.dart';
import 'package:pharmabox/custom_code/widgets/progress_indicator.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_drop_down.dart';
import 'package:pharmabox/flutter_flow/form_field_controller.dart';
import 'package:pharmabox/pharma_job/pharmaJobSearchData.dart';
import 'package:pharmabox/pharmablabla/pharmablabla_model.dart';
import 'package:pharmabox/popups/popup_groupement/popup_groupement_widget.dart';
import 'package:pharmabox/popups/popup_lgo/popup_lgo_widget.dart';
import 'package:pharmabox/popups/popup_pharmablabla/popup_pharmablabla_widget.dart';

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

class PharmaBlablaAddPost extends StatefulWidget {
  const PharmaBlablaAddPost({Key? key}) : super(key: key);

  @override
  _PharmaBlablaAddPostState createState() => _PharmaBlablaAddPostState();
}

class _PharmaBlablaAddPostState extends State<PharmaBlablaAddPost> {
  late PharmaBlablaModel _model;
  bool isTitulaire = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  void changeReseauType() {
    if (_model.reseauType == 'Tout Pharmabox') {
      setState(() {
        _model.reseauType = 'Mon réseau';
      });
    } else {
      setState(() {
        _model.reseauType = 'Tout Pharmabox';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PharmaBlablaModel());
    _model.postContent ??= TextEditingController();
    checkIsTitulaire().then((isTitulaire) {
      setState(() {
        this.isTitulaire = isTitulaire;
      });
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Map<String, dynamic> testData = {
    'poste': 'Pharmacien(ne)',
    'nom': 'Berrebi',
    'prenom': 'Aviel',
    'post_content':
        'Comment faire pour accéder à un compte utilisateur sur le logiciel LGO Winpharma ?',
    'id': 'dggdgdgdzg',
    'photoUrl': ''
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            wrapWithModel(
              model: _model.headerAppModel,
              updateCallback: () => setState(() {}),
              child: HeaderAppWidget(),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Ajouter un post',
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
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      shape: BoxShape.circle,
                    ),
                    child: FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 30.0,
                      borderWidth: 1.0,
                      buttonSize: 40.0,
                      icon: Icon(
                        Icons.tune,
                        color: greyColor,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          enableDrag: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (bottomSheetContext) {
                            return DraggableScrollableSheet(
                                initialChildSize: 0.75,
                                builder: (BuildContext context,
                                    ScrollController scrollController) {
                                  return Padding(
                                    padding: MediaQuery.of(bottomSheetContext)
                                        .viewInsets,
                                    child: PopupPharmaBlabla(),
                                  );
                                });
                          },
                        ).then((value) => setState(() {}));
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
              child: Text(
                'Filtres de publication',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Poppins', color: Colors.black, fontSize: 14),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 5.0, 15.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        color: Color(0xFFD0D1DE),
                      ),
                    ),
                    height: 50,
                    child: TextButton(
                        onPressed: () {
                          changeReseauType();
                        },
                        child: Row(
                          children: [
                            PharmaboxLogo(width: 25),
                            SizedBox(width: 5),
                            Text(_model.reseauType,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                        fontFamily: 'Poppins',
                                        color: Colors.black,
                                        fontSize: 12)),
                          ],
                        )),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(
                          color: Color(0xFFD0D1DE),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                5.0, 0.0, 0.0, 0.0),
                            child: Icon(
                              Icons.work_outline,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                          ),
                          FlutterFlowDropDown<String>(
                            hintText: 'Tous',
                            controller: _model.posteValueController ??=
                                FormFieldController<String>('Tous'),
                            options: [
                              'Tous',
                              'Rayonniste',
                              'Conseiller',
                              'Préparateur',
                              'Apprenti',
                              'Etudiant pharmacie',
                              'Etudiant pharmacie 6ème année validée',
                              'Pharmacien(ne)'
                            ],
                            onChanged: (val) =>
                                setState(() => _model.posteValue = val),
                            width: MediaQuery.of(context).size.width * 0.46,
                            height: 50.0,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                    fontSize: 12),
                            fillColor: Colors.white,
                            elevation: 2.0,
                            borderColor: Colors.transparent,
                            borderWidth: 0.0,
                            borderRadius: 0.0,
                            margin: EdgeInsetsDirectional.fromSTEB(
                                12.0, 4.0, 12.0, 4.0),
                            hidesUnderline: true,
                            isSearchable: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 5.0, 15.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        color: Color(0xFFD0D1DE),
                      ),
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
                              return DraggableScrollableSheet(builder:
                                  (BuildContext context,
                                      ScrollController scrollController) {
                                return GestureDetector(
                                  onTap: () => '',
                                  child: Padding(
                                    padding: MediaQuery.of(bottomSheetContext)
                                        .viewInsets,
                                    child: PopupLgoWidget(
                                      onTap: (lgo) {
                                        print(lgo);
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
                            PharmaboxLogo(width: 25),
                            SizedBox(width: 5),
                            Text(_model.reseauType,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                        fontFamily: 'Poppins',
                                        color: Colors.black,
                                        fontSize: 12)),
                          ],
                        )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        color: Color(0xFFD0D1DE),
                      ),
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
                              return DraggableScrollableSheet(builder:
                                  (BuildContext context,
                                      ScrollController scrollController) {
                                return GestureDetector(
                                  onTap: () => '',
                                  child: Padding(
                                    padding: MediaQuery.of(bottomSheetContext)
                                        .viewInsets,
                                    child: PopupGroupementWidget(
                                      onTap: (groupement) {
                                        print(groupement);
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
                            PharmaboxLogo(width: 25),
                            SizedBox(width: 5),
                            Text(_model.reseauType,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                        fontFamily: 'Poppins',
                                        color: Colors.black,
                                        fontSize: 12)),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
              child: Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      color: Color(0x2B1F5C67),
                      offset: Offset(10, 10),
                    )
                  ],
                  borderRadius: BorderRadius.circular(15),
                  shape: BoxShape.rectangle,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lancez un sujet ...',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: 'Poppins',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: TextFormField(
                          minLines: 10,
                          controller: _model.postContent,
                          obscureText: false,
                          decoration: InputDecoration(
                            filled: true, //<-- SEE HERE
                            fillColor: Colors.white,
                            labelText: 'Ecrivez votre message ici',
                            hintStyle: FlutterFlowTheme.of(context).bodySmall,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFD0D1DE),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).focusColor,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x301F5C67),
                                offset: Offset(0.0, 4.0),
                              )
                            ],
                            gradient: LinearGradient(
                              colors: [Color(0xFF7CEDAC), Color(0xFF42D2FF)],
                              stops: [0.0, 1.0],
                              begin: AlignmentDirectional(1.0, -1.0),
                              end: AlignmentDirectional(-1.0, 1.0),
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: FFButtonWidget(
                            onPressed: () async {
                              await Future.delayed(Duration(seconds: 2));
                            },
                            text: 'Publier',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0x00FFFFFF),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
