import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmabox/composants/card_offers_profile/card_offers_profile.dart';
import 'package:pharmabox/custom_code/widgets/horaire_select_widget.dart';
import 'package:pharmabox/custom_code/widgets/index.dart';
import 'package:pharmabox/custom_code/widgets/progress_indicator.dart';

import '../composants/card_pharmacie/card_pharmacie_widget.dart';
import '../composants/card_user/card_user_widget.dart';
import '../constant.dart';
import '../custom_code/widgets/levelProgressBar.dart';
import '../custom_code/widgets/like_button.dart';
import '/composants/header_app/header_app_widget.dart';
import '/composants/list_skill_with_slider/list_skill_with_slider_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/popups/popup_profil/popup_profil_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'profil_view_pharmacie_model.dart';
export 'profil_view_pharmacie_model.dart';

class PharmacieProfilView extends StatefulWidget {
  const PharmacieProfilView({
    Key? key,
    String? pharmacieId,
  })  : this.pharmacieId = pharmacieId ?? '',
        super(key: key);

  final String pharmacieId;

  @override
  _PharmacieProfilViewState createState() => _PharmacieProfilViewState();
}

class _PharmacieProfilViewState extends State<PharmacieProfilView> with SingleTickerProviderStateMixin {
  late PharmacieProfilViewModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  var pharmacieData;
  var userData;
  bool isExpanded_Titu = false;
  bool isExpanded_NonTitu = false;
  bool isExpanded_Pharma = false;
  bool _isLoading = false;

  List titulairesNetwork = [];
  List nonTitulairesNetwork = [];
  List pharmaciesNetwork = [];

  List offresPharma = [];

  TabController? _tabController;
  int _selectedIndex = 0;

  Future<void> getNetworkData() async {
    // Use collection group to make query across all collections
    QuerySnapshot queryUsers = await FirebaseFirestore.instance.collection('users').where('reseau', arrayContains: widget.pharmacieId).get();

    QuerySnapshot queryPharmacies = await FirebaseFirestore.instance.collection('pharmacies').where('reseau', arrayContains: widget.pharmacieId).get();

    for (var doc in queryPharmacies?.docs ?? []) {
      var data = doc.data();
      data['documentId'] = doc.id;
      pharmaciesNetwork.add(data);
    }

    // Split users based on their 'poste' field
    for (var doc in queryUsers.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data != null && data['poste'] == 'Pharmacien(ne) titulaire') {
        titulairesNetwork.add(data);
      } else {
        nonTitulairesNetwork.add(data);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PharmacieProfilViewModel());
    _tabController = TabController(length: 3, vsync: this);

    getpharmacieData();
    getNetworkData();
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  getpharmacieData() async {
    setState(() {
      _isLoading = true;
    });
    QuerySnapshot offres = await FirebaseFirestore.instance.collection('offres').where('pharmacie_id', isEqualTo: widget.pharmacieId).get();

    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('pharmacies').doc(widget.pharmacieId).get();

    if (docSnapshot.exists) {
      // Accéder aux données du document.
      var data = docSnapshot.data();
      setState(() {
        pharmacieData = data;
      });
      for (var doc in offres.docs) {
        var docData = doc.data() as Map<String, dynamic>;

        docData['doc_id'] = doc.id;
        docData['localisation_job'] = pharmacieData['situation_geographique']['data']['rue'] + ', ' + pharmacieData['situation_geographique']['data']['ville'] + ', ' + pharmacieData['situation_geographique']['data']['postcode'];
        offresPharma.add(docData);
      }
    } else {
      // Gérer le cas où les données de l'utilisateur n'existent pas.
      return;
    }
    setState(() {
      _isLoading = false;
    });
  }

  getuserData(String userId) async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (docSnapshot.exists) {
      // Accéder aux données du document.
      var data = docSnapshot.data();
      setState(() {
        userData = data;
      });
    } else {
      // Gérer le cas où les données de l'utilisateur n'existent pas.
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    getuserData(pharmacieData != null ? pharmacieData['user_id'] : '');

    if (_isLoading) {
      return ProgressIndicatorPharmabox();
    } else {
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
              Container(
                width: MediaQuery.of(context).size.width * 1.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CarouselPharmacieSliderSelect(
                        onImagesSelected: (urls) {},
                        isEditable: false,
                        initialImagesSelected: pharmacieData != null && pharmacieData['photo_url'] != '' ? pharmacieData['photo_url'].cast<String>() : [''],
                        pharmacieId: widget.pharmacieId,
                        data: pharmacieData,
                        userData: userData,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 1.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Titulaire', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 18.0, fontWeight: FontWeight.w600)),
                                      SizedBox(height: 15),
                                      GestureDetector(
                                        onTap: () => {
                                          context.pushNamed('ProfilView',
                                              queryParams: {
                                                'userId': serializeParam(
                                                  userData['id'],
                                                  ParamType.String,
                                                ),
                                              }.withoutNulls)
                                        },
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
                                                  child: userData != null && userData['photoUrl'] != ''
                                                      ? Image.network(
                                                          userData['photoUrl'],
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.asset('assets/images/Group_18.png', fit: BoxFit.cover)),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.30,
                                              child: Text(
                                                userData != null ? userData['nom'] + ' ' + userData['prenom'] : '',
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      fontFamily: 'Poppins',
                                                      color: blackColor,
                                                      fontSize: 14.0,
                                                    ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 0.0, 0.0),
                                              child: Icon(
                                                FFIcons.kbadgeOr,
                                                color: Color(0xFFFFF492),
                                                size: 24.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  // width: MediaQuery.of(context).size.width * 0.50,
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text('Groupement', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 18.0, fontWeight: FontWeight.w600)),
                                    SizedBox(height: 15),
                                    if (pharmacieData['groupement'][0]['image'].toString() != 'Autre.jpg')
                                      Image.asset(
                                        'assets/groupements/' + pharmacieData['groupement'][0]['image'].toString(),
                                        width: 150.0,
                                        height: 50.0,
                                        fit: BoxFit.cover,
                                      ),
                                    if (pharmacieData['groupement'][0]['image'].toString() == 'Autre.jpg')
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15.0),
                                        child: Text(pharmacieData['groupement'][0]['name'].toString(),
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: 'Poppins',
                                                  color: blackColor,
                                                  fontSize: 14.0,
                                                )),
                                      )
                                  ]),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(pharmacieData != null ? pharmacieData['presentation'] : '', style: FlutterFlowTheme.of(context).bodyMedium)
                          ]),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 1.0,
                        // height: MediaQuery.of(context).size.height * 1,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        child: TabBar(
                          onTap: (value) {
                            setState(() {
                              _selectedIndex = value;
                            });
                          },
                          controller: _tabController,
                          labelColor: blackColor,
                          unselectedLabelColor: blackColor,
                          indicator: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF7CEDAC),
                                Color(0xFF42D2FF),
                              ],
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          indicatorWeight: 1,
                          indicatorPadding: EdgeInsets.only(top: 40),
                          unselectedLabelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Poppins',
                                color: Color(0xFF595A71),
                                fontSize: 14.0,
                              ),
                          labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 14.0, fontWeight: FontWeight.w600),
                          tabs: [
                            Tab(
                              text: 'Profil',
                            ),
                            Tab(
                              text: 'Offres',
                            ),
                          ],
                        ),
                      ),
                      if (_selectedIndex == 0)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFEFF6F7),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 12,
                                        color: Color(0x2B1F5C67),
                                        offset: Offset(10, 10),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).secondaryBackground,
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
                                                'Contact',
                                                style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                      fontFamily: 'Poppins',
                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                                child: Row(children: [
                                                  Icon(
                                                    Icons.mail_outline,
                                                    color: greyColor,
                                                    size: 28.0,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(pharmacieData['contact_pharma']['email'], style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                                ]),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                                child: Row(children: [
                                                  Icon(
                                                    Icons.phone,
                                                    color: greyColor,
                                                    size: 28.0,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(pharmacieData['contact_pharma']['telephone'], style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                                ]),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                            borderRadius: BorderRadius.circular(15),
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Situation géographique',
                                                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme.of(context).primaryText,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: MapAdressePharmacie(
                                            isEditable: false,
                                            onAdressSelected: (latitude, longitude, adresse, postcode, ville, arrondissement, region) => {},
                                            onInitialValue: pharmacieData['situation_geographique']['data']['rue'] + ', ' + pharmacieData['situation_geographique']['data']['ville'] + ', ' + pharmacieData['situation_geographique']['data']['postcode'],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                                              'Accessibilité',
                                              style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                    fontFamily: 'Poppins',
                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        if (pharmacieData['accessibilite']['bus'] != '')
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.directions_bus,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text(pharmacieData['accessibilite']['bus'], style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['accessibilite']['gare'] != '')
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.departure_board,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text(pharmacieData['accessibilite']['gare'], style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['accessibilite']['metro'] != '')
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.subway_outlined,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text(pharmacieData['accessibilite']['metro'], style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['accessibilite']['rer'] != '')
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.train,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10),
                                              Text(pharmacieData['accessibilite']['rer'], style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['accessibilite']['tram'] != '')
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.tram_outlined,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text(pharmacieData['accessibilite']['tram'], style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['accessibilite']['stationnement'] != '')
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.local_parking,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text(pharmacieData['accessibilite']['stationnement'] ?? '', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                                              'Horaires',
                                              style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                    fontFamily: 'Poppins',
                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        HorraireSemaineSelect(
                                          isEditable: false,
                                          initialHours: pharmacieData['horaires'],
                                          callback: (listHoraire) {},
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                                              'Typologie',
                                              style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                    fontFamily: 'Poppins',
                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        if (pharmacieData['typologie'] != null && pharmacieData['typologie'] == 'Quartier')
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.holiday_village_outlined,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text('Quartier', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['typologie'] != null && pharmacieData['typologie'] == 'Centre ville')
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.apartment_outlined,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text('Centre ville', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['typologie'] != null && pharmacieData['typologie'] == 'Aéroport')
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.flight_takeoff,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text('Aéroport', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['typologie'] != null && pharmacieData['typologie'] == 'Gare')
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.train,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10),
                                              Text('Gare', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['typologie'] != null && pharmacieData['typologie'] == 'Centre commercial')
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.store_mall_directory_outlined,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text('Centre commercial', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['typologie'] != null && pharmacieData['typologie'] == 'Lieu touristique')
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.landscape_outlined,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text('Lieu touristique', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['typologie'] != null && pharmacieData['typologie'] == 'Zone rurale')
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.nature_people_outlined,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text('Zone rurale', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['nb_patient_jour'] != null && pharmacieData['nb_patient_jour'] != '')
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 15.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.groups,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text(pharmacieData['nb_patient_jour'] + ' patients par jour', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                                              'Missions',
                                              style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                    fontFamily: 'Poppins',
                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        if (pharmacieData['missions'] != '' && pharmacieData['missions'].contains('Test COVID'))
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 15.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.coronavirus_outlined,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text('Test COVID', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['missions'] != '' && pharmacieData['missions'].contains('Vaccination'))
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 15.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.vaccines,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text('Vaccination', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['missions'] != '' && pharmacieData['missions'].contains('Entretien pharmaceutique'))
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 15.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.health_and_safety_outlined,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text('Entretien pharmaceutique', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['missions'] != '' && pharmacieData['missions'].contains('Borne de télé-médecine'))
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 15.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.local_pharmacy_outlined,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text('Borne de télé-médecine', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['missions'] != '' && pharmacieData['missions'].contains('externalisé'))
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 15.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.videocam_outlined,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text('Préparation externalisé', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                                              'LGO',
                                              style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                    fontFamily: 'Poppins',
                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.8,
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Image.asset(
                                                    'assets/lgo/' + pharmacieData['lgo'][0]['image'],
                                                    width: 120,
                                                    height: 60,
                                                    fit: BoxFit.contain,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                                    child: Text(
                                                      pharmacieData['lgo'][0]['name'],
                                                      style: FlutterFlowTheme.of(context).bodyMedium,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                                              'Confort',
                                              style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                    fontFamily: 'Poppins',
                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        if (pharmacieData['confort'] != '' && pharmacieData['confort'].contains('Salle de pause'))
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 15.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.self_improvement,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text('Salle de pause', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['confort'] != '' && pharmacieData['confort'].contains('Robot'))
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 15.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.smart_toy_outlined,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text('Robot', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['confort'] != '' && pharmacieData['confort'].contains('Etiquettes éléctroniques'))
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 15.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.qr_code_outlined,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text('Etiquettes éléctroniques', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['confort'] != '' && pharmacieData['confort'].contains('Monnayeur'))
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 15.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.point_of_sale,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text('Monnayeur', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['confort'] != '' && pharmacieData['confort'].contains('Climatisation'))
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 15.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.ac_unit,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text('Climatisation', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['confort'] != '' && pharmacieData['confort'].contains('Chauffage'))
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 15.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.light_mode_outlined,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text('Chauffage', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['confort'] != '' && pharmacieData['confort'].contains('Vigile'))
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 15.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.local_police_outlined,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text('Vigile', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                        if (pharmacieData['confort'] != '' && pharmacieData['confort'].contains('Comité d\'entreprise'))
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 15.0),
                                            child: Row(children: [
                                              Icon(
                                                Icons.groups,
                                                color: greyColor,
                                                size: 28.0,
                                              ),
                                              SizedBox(width: 10, height: 30),
                                              Text('Comité d\'entreprise', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                            ]),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                                              'Tendances',
                                              style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                    fontFamily: 'Poppins',
                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Row(children: [
                                          Icon(
                                            Icons.description_outlined,
                                            color: greyColor,
                                            size: 28.0,
                                          ),
                                          SizedBox(width: 10, height: 30),
                                          Text('Ordonnances', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16)),
                                          LevelProgressBar(
                                            level: pharmacieData['tendances'][0]['Ordonances'],
                                            isUser: false,
                                          )
                                        ]),
                                        Row(children: [
                                          Icon(
                                            Icons.face_retouching_natural_outlined,
                                            color: greyColor,
                                            size: 28.0,
                                          ),
                                          SizedBox(width: 10, height: 30),
                                          Text('Cosmétiques', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16)),
                                          LevelProgressBar(
                                            level: pharmacieData['tendances'][0]['Cosmétiques'],
                                            isUser: false,
                                          )
                                        ]),
                                        Row(children: [
                                          Icon(
                                            Icons.yard_outlined,
                                            color: greyColor,
                                            size: 28.0,
                                          ),
                                          SizedBox(width: 10, height: 30),
                                          Text('Phyto / aroma', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16)),
                                          LevelProgressBar(
                                            level: pharmacieData['tendances'][0]['Phyto / aroma'],
                                            isUser: false,
                                          )
                                        ]),
                                        Row(children: [
                                          Icon(
                                            Icons.lunch_dining_outlined,
                                            color: greyColor,
                                            size: 28.0,
                                          ),
                                          SizedBox(width: 10, height: 30),
                                          Text('Nutrition', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16)),
                                          LevelProgressBar(
                                            level: pharmacieData['tendances'][0]['Nutrition'],
                                            isUser: false,
                                          )
                                        ]),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.live_help_outlined,
                                              color: greyColor,
                                              size: 28.0,
                                            ),
                                            SizedBox(width: 10, height: 30),
                                            Text('Conseil', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16)),
                                            LevelProgressBar(
                                              level: pharmacieData['tendances'][0]['Conseil'],
                                              isUser: false,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_selectedIndex == 1 && offresPharma.isNotEmpty)
                        for (var searchI in offresPharma)
                          CardOfferProfilWidget(
                            searchI: searchI,
                            isEditable: false,
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
}
