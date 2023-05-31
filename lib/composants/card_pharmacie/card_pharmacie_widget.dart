import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmabox/constant.dart';

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
  const CardPharmacieWidget(
      {Key? key, this.data, this.profilUid, this.dataKey = 0})
      : super(key: key);

  final data;
  final profilUid;
  final dataKey;
  @override
  _CardPharmacieWidgetState createState() => _CardPharmacieWidgetState();
}

class _CardPharmacieWidgetState extends State<CardPharmacieWidget> {
  late CardPharmacieModel _model;
  String _postcodeAdresse = '';
  String _imageProfilPharma = '';
  late bool isLiked;
  late int likeCount;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CardPharmacieModel());
    getCityAndPostalCode(
        widget.data[widget.dataKey]['situation_geographique']['lat_lng'][0],
        widget.data[widget.dataKey]['situation_geographique']['lat_lng'][1]);

    setImageProfile();
    // likeCount = widget.data['likeCount'] ?? 0;
    // List<dynamic> likedBy = widget.data['likedBy'] ?? [];
    // isLiked = likedBy.contains(getCurrentUserId());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  getCityAndPostalCode(double latitude, double longitude) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$googleMapsApi';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final results = data['results'] as List<dynamic>;
        if (results.isNotEmpty) {
          final addressComponents =
              results[0]['address_components'] as List<dynamic>;

          String postalCode = '';
          String city = '';

          for (var component in addressComponents) {
            final types = component['types'] as List<dynamic>;
            if (types.contains('postal_code')) {
              postalCode = component['long_name'] as String;
            }
            if (types.contains('locality')) {
              city = component['long_name'] as String;
            }
          }

          if (postalCode.isNotEmpty && city.isNotEmpty) {
            setState(() {
              _postcodeAdresse = '$postalCode, $city';
            });
          }
        }
      }
    }

    return '';
  }

  setImageProfile() {
    // if (widget.data[widget.dataKey]['photo_url'] != '') {
    //   _imageProfilPharma = widget.data[widget.dataKey]['photo_url'].toString();
    // }
  }

Future<String> getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    }
    return '';
  }

void updateLike(bool liked) async {
  final String currentUserId = await getCurrentUserId();
  final DocumentReference<Map<String, dynamic>> documentRef =
      FirebaseFirestore.instance
          .collection('pharmacies')
          .doc(widget.data[widget.dataKey]['documentId']);

  final currentLikeCount = liked ? 1 : -1;

  await documentRef.update({
    'likeCount': FieldValue.increment(currentLikeCount),
    'isLiked': liked,
    'likedBy': liked
        ? FieldValue.arrayUnion([currentUserId])
        : FieldValue.arrayRemove([currentUserId])
  });
}

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 1.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(15.0),
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
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.network(
                    _imageProfilPharma,
                  ).image,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 10.0),
                    child: Image.asset(
                      'assets/images/Badge.png',
                      width: 40.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 10.0),
                    child: Image.asset(
                      'assets/images/Badge2.png',
                      width: 40.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Container(
                          width: 120,
                          child: Text(
                            widget.data[widget.dataKey]
                                    ['situation_geographique']['adresse']
                                .toString(),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF161730),
                                  fontSize: 16.0,
                                ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(
                      'assets/groupements/' +
                          widget.data[widget.dataKey]['groupement'][0]['image']
                              .toString(),
                      width: 80.0,
                      height: 50.0,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 120,
                          child: Text(
                            widget.data[widget.dataKey]['groupement'][0]['name']
                                .toString(),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF595A71),
                                  fontSize: 14.0,
                                ),
                          ),
                        )),
                  ],
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
                      Icons.location_on_outlined,
                      color: Color(0xFF595A71),
                      size: 35.0,
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                      child: Text(
                        _postcodeAdresse,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Poppins',
                              color: Color(0xFF595A71),
                            ),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: custom_widgets.GradientTextCustom(
                    width: 30,
                    radius: 12.0,
                    fontSize: 14,
                    text: 'Ajouter',
                    height: 25.0,
                    action: () async {},
                  ),
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
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 5.0, 0.0),
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
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  2.0, 2.0, 2.0, 2.0),
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
                                onPressed: () {
                                  print('IconButton pressed ...');
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 5.0, 0.0),
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
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  2.0, 2.0, 2.0, 2.0),
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
                                onPressed: () {
                                  print('IconButton pressed ...');
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
                            padding: EdgeInsetsDirectional.fromSTEB(
                                2.0, 2.0, 2.0, 2.0),
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
                                print('IconButton pressed ...');
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
    );
  }
}
