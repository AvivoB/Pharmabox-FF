import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmabox/custom_code/widgets/carousel_widget_pharma.dart';
import 'package:pharmabox/discussion_user/discussion_user_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../custom_code/widgets/like_button.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'card_pharmacie_offre_recherche_model.dart';
export 'card_pharmacie_offre_recherche_model.dart';

class CardPharmacieOffreRechercheWidget extends StatefulWidget {
  const CardPharmacieOffreRechercheWidget({Key? key, this.data}) : super(key: key);

  final data;

  @override
  _CardPharmacieOffreRechercheWidgetState createState() => _CardPharmacieOffreRechercheWidgetState();
}

class _CardPharmacieOffreRechercheWidgetState extends State<CardPharmacieOffreRechercheWidget> {
  late CardPharmacieOffreRechercheModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CardPharmacieOffreRechercheModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int lengthAvantages = widget.data['offre']['avantages']?.length ?? 0;
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
                  imageNames: widget.data['pharma_data']['photo_url'],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.pushNamed('PharmacieProfilView',
                                  queryParameters: {
                                    'pharmacieId': widget.data['pharma_id'],
                                  });
                            },
                            child: Text(
                              widget.data['pharma_data']['situation_geographique'] != null ? widget.data['pharma_data']['situation_geographique']['adresse'] : '',
                              overflow: TextOverflow.clip,
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF161730),
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 10.0, 15.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Color(0xFF595A71),
                          size: 35.0,
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                            child: Text(
                              widget.data['pharma_data']['situation_geographique'] != null ? widget.data['pharma_data']['situation_geographique']['data']['ville'] + ', ' + widget.data['pharma_data']['situation_geographique']['data']['country'] : '',
                              overflow: TextOverflow.clip,
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF595A71),
                                  ),
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.32,
                    child: Image.asset(
                      'assets/groupements/' + widget.data['pharma_data']['groupement'][0]['image'].toString(),
                      width: 150.0,
                      height: 50.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
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
                        Icons.work_outline_outlined,
                        color: widget.data['offre']['avantages'] != null && lengthAvantages >= 5 ? Color(0xFFFFF492) : Color(0xFF595A71),
                        size: 35.0,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                        child: Text(
                          widget.data['offre']['poste'] != null ? widget.data['offre']['poste'] : '',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Poppins',
                                color: Color(0xFF595A71),
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
                    // Container(
                    //     width: 100.0,
                    //     height: 50.0,
                    //     decoration: BoxDecoration(
                    //       color: FlutterFlowTheme.of(context).secondaryBackground,
                    //       borderRadius: BorderRadius.circular(50.0),
                    //     ),
                    //     child: LikeButtonWidget(documentId: widget.data['offer_id'])),
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
                                    if (widget.data['pharma_data']['contact_pharma']['preference_contact'] != 'Personnel') {
                                      await launch('tel:' + widget.data['pharma_data']['contact_pharma']['telephone']);
                                    } else {
                                      await launch('tel:' + widget.data['user_data']['telephone']);
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
                                    size: 22.0,
                                  ),
                                  onPressed: () async {
                                    if (widget.data['pharma_data']['contact_pharma']['preference_contact'] != 'Personnel') {
                                      await launch('mailto:' + widget.data['pharma_data']['contact_pharma']['email']);
                                    } else {
                                      await launch('mailto:' + widget.data['user_data']['email']);
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
                                  size: 22.0,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DiscussionUserWidget(toUser: widget.data['pharma_data']['user_id']),
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
