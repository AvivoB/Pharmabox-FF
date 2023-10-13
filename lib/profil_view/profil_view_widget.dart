import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmabox/composants/card_offers_profile/card_offers_profile.dart';
import 'package:pharmabox/composants/card_searchs_profile/card_searchs_profile.dart';
import 'package:pharmabox/custom_code/widgets/button_network_manager.dart';
import 'package:pharmabox/custom_code/widgets/progress_indicator.dart';
import 'package:pharmabox/discussion_user/discussion_user_widget.dart';
import 'package:pharmabox/popups/popup_signalement/popup_signalement_widget.dart';

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
import 'profil_view_model.dart';
export 'profil_view_model.dart';

class ProfilViewWidget extends StatefulWidget {
  const ProfilViewWidget({
    Key? key,
    String? userId,
  })  : this.userId = userId ?? '',
        super(key: key);

  final String userId;

  @override
  _ProfilViewWidgetState createState() => _ProfilViewWidgetState();
}

class _ProfilViewWidgetState extends State<ProfilViewWidget> with SingleTickerProviderStateMixin {
  late ProfilViewModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  var userData;
  List recherchesUser = [];
  List offresUser = [];
  List pharmacieUser = [];
  bool isExpanded_Titu = false;
  bool isExpanded_NonTitu = false;
  bool isExpanded_Pharma = false;

  List titulairesNetwork = [];
  List networkUser = [];
  List pharmaciesNetwork = [];

  bool _isLoading = false;

  TabController? _tabController;
  int _selectedIndex = 0;

  Future<void> getNetworkData() async {
    // Use collection group to make query across all collections
    QuerySnapshot queryUsers = await FirebaseFirestore.instance.collection('users').where('reseau', arrayContains: widget.userId).get();

    QuerySnapshot queryPharmacies = await FirebaseFirestore.instance.collection('pharmacies').where('reseau', arrayContains: widget.userId).get();

    for (var doc in queryPharmacies?.docs ?? []) {
      var data = doc.data();
      data['documentId'] = doc.id;
      data['type'] = 'pharmacie';
      networkUser.add(data);
    }

    // Split users based on their 'poste' field
    for (var doc in queryUsers?.docs ?? []) {
      var data = doc.data();
      data['type'] = 'user';
      networkUser.add(data);
    }
  }

  calculateAge(String birthDate) {
    if (birthDate != '') {
      // Convertit la chaîne en DateTime
      List<String> birthDateParts = birthDate.split("/");
      DateTime birthDateTime = DateTime(
        int.parse(birthDateParts[2]), // year
        int.parse(birthDateParts[1]), // month
        int.parse(birthDateParts[0]), // day
      );

      // Calcule l'âge
      DateTime currentDate = DateTime.now();
      int age = currentDate.year - birthDateTime.year;
      if (birthDateTime.month > currentDate.month || (birthDateTime.month == currentDate.month && birthDateTime.day > currentDate.day)) {
        age--;
      }
      return age.toString();
    } else {
      return '';
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfilViewModel());
    _tabController = TabController(length: 3, vsync: this);

    getUserData();
    getNetworkData();
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  getUserData() async {
    setState(() {
      _isLoading = true;
    });
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Gérer le cas où l'utilisateur n'est pas connecté.
      return;
    }

    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();

    QuerySnapshot recherches = await FirebaseFirestore.instance.collection('recherches').where('user_id', isEqualTo: widget.userId).get();
    QuerySnapshot offres = await FirebaseFirestore.instance.collection('offres').where('user_id', isEqualTo: widget.userId).get();
    QuerySnapshot pharmacie = await FirebaseFirestore.instance.collection('pharmacies').where('user_id', isEqualTo: widget.userId).get();

    if (docSnapshot.exists) {
      // Accéder aux données du document.
      var data = docSnapshot.data();
      setState(() {
        userData = data;
        for (var doc in recherches.docs) {
          var docData = doc.data() as Map<String, dynamic>;
          docData['doc_id'] = doc.id;
          recherchesUser.add(docData);
        }
        for (var doc in offres.docs) {
          var docData = doc.data() as Map<String, dynamic>;
          docData['doc_id'] = doc.id;
          offresUser.add(docData);
        }
        for (var doc in pharmacie.docs) {
          var docData = doc.data() as Map<String, dynamic>;
          docData['doc_id'] = doc.id;
          pharmacieUser.add(docData);
        }
      });
    } else {
      // Gérer le cas où les données de l'utilisateur n'existent pas.
      return;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: ProgressIndicatorPharmabox());
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
                      Container(
                        width: MediaQuery.of(context).size.width * 1.0,
                        // height: MediaQuery.of(context).size.height * 0.30,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF7F7FD5), Color(0xFF86A8E7), Color(0xFF91EAE4)],
                            stops: [0.0, 0.5, 1.0],
                            begin: AlignmentDirectional(1.0, 0.34),
                            end: AlignmentDirectional(-1.0, -0.34),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.chevron_left),
                                        iconSize: 30,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 7,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                              shape: BoxShape.circle,
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.flag_outlined,
                                                color: redColor,
                                              ),
                                              iconSize: 30,
                                              onPressed: () async {
                                                await showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  backgroundColor: Colors.transparent,
                                                  enableDrag: true,
                                                  context: context,
                                                  builder: (bottomSheetContext) {
                                                    return Padding(padding: MediaQuery.of(bottomSheetContext).viewInsets, child: PopupSignalement(docId: widget.userId, collectionName: 'users'));
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                              child: ButtonNetworkManager(
                                            width: 30,
                                            radius: 12.0,
                                            fontSize: 14,
                                            text: 'Ajouter',
                                            height: 25.0,
                                            typeCollection: 'users',
                                            docId: widget.userId,
                                          )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.50,
                                        height: 150.0,
                                        child: Stack(
                                          alignment: AlignmentDirectional(0.0, 1.0),
                                          children: [
                                            Container(
                                              width: 150.0,
                                              height: 150.0,
                                              decoration: BoxDecoration(
                                                color: Color(0x00FFFFFF),
                                                borderRadius: BorderRadius.circular(95.0),
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 2.0,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(7.0, 7.0, 7.0, 7.0),
                                                child: Container(
                                                    width: 150.0,
                                                    height: 150.0,
                                                    clipBehavior: Clip.antiAlias,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: (userData != null && userData['photoUrl'] != null && userData['photoUrl'].isNotEmpty)
                                                        ? Image.network(
                                                            userData['photoUrl'],
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.asset(
                                                            'assets/images/Group_18.png',
                                                            fit: BoxFit.cover,
                                                          )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
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
                                                      onPressed: () {
                                                        print('IconButton pressed ...');
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
                                                          builder: (context) => DiscussionUserWidget(toUser: widget.userId),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.50,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData != null ? userData['prenom'] + ' ' + userData['nom'] : '',
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Poppins',
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        if (userData != null && userData['poste'] != 'Pharmacien(ne) titulaire')
                                          Text(
                                            userData != null ? userData['poste'] : '',
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.white,
                                                ),
                                          ),
                                        if (userData != null && userData['poste'] == 'Pharmacien(ne) titulaire')
                                          GestureDetector(
                                            onTap: () {
                                              context.pushNamed('PharmacieProfilView',
                                                  queryParams: {
                                                    'pharmacieId': serializeParam(
                                                      pharmacieUser[0]['doc_id'],
                                                      ParamType.String,
                                                    ),
                                                  }.withoutNulls);
                                            },
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 10.0, 0.0),
                                              child: Row(children: [
                                                pharmacieUser[0]['photo_url'].isNotEmpty
                                                    ? Container(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        clipBehavior: Clip.antiAlias,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Image.network(
                                                          pharmacieUser[0]['photo_url'][0],
                                                          fit: BoxFit.cover,
                                                        ))
                                                    : Container(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        clipBehavior: Clip.antiAlias,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Image.asset(
                                                          'assets/images/Group_19.png',
                                                          fit: BoxFit.cover,
                                                        )),
                                                SizedBox(width: 10),
                                                Flexible(
                                                  child: Text(pharmacieUser[0]['situation_geographique']['adresse'].toString(),
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: 'Poppins',
                                                            color: Colors.white,
                                                          )),
                                                )
                                              ]),
                                            ),
                                          ),
                                        Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                                            child: LikeButtonWidget(
                                              documentId: userData != null ? userData['id'] : '',
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 1.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            if (userData != null && userData['date_naissance'] != '')
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.cake,
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      size: 24,
                                    ),
                                    SizedBox(width: 5),
                                    Text(userData['date_naissance'] != null ? calculateAge(userData['date_naissance']) + ' ans' : '', style: FlutterFlowTheme.of(context).bodyMedium)
                                  ],
                                ),
                              ),
                            if (userData['country'] != null)
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.place,
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      size: 24,
                                    ),
                                    SizedBox(width: 5),
                                    Text(userData != null && userData['city'] != null ? userData['city'] + ', ' + userData['country'] ?? '' : '', style: FlutterFlowTheme.of(context).bodyMedium)
                                  ],
                                ),
                              ),
                            if (userData['country'] == null)
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.place,
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      size: 24,
                                    ),
                                    SizedBox(width: 5),
                                    Text(userData != null && userData['city'] != null ? userData['city'] : '', style: FlutterFlowTheme.of(context).bodyMedium)
                                  ],
                                ),
                              ),
                            if (userData != null && userData['email'] != '')
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.mail_outline,
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      size: 24,
                                    ),
                                    SizedBox(width: 5),
                                    Text(userData['email'] ?? '', style: FlutterFlowTheme.of(context).bodyMedium)
                                  ],
                                ),
                              ),
                            if (userData['telephone'] != '' && userData['afficher_tel'])
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.call,
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      size: 24,
                                    ),
                                    SizedBox(width: 5),
                                    Text(userData['telephone'], style: FlutterFlowTheme.of(context).bodyMedium)
                                  ],
                                ),
                              ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(userData != null ? userData['presentation'] : '', style: FlutterFlowTheme.of(context).bodyMedium)
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
                              text: 'Réseau',
                            ),
                            Tab(
                              text: userData != null && userData['poste'] == 'Pharmacien(ne) titulaire' ? 'Offres' : 'Recherches',
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
                                                'Spécialisations',
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
                                                padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                  ),
                                                  child: ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    scrollDirection: Axis.vertical,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemCount: userData != null ? userData['specialisations'].length : 0,
                                                    itemBuilder: (context, index) {
                                                      return Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Icon(
                                                              Icons.verified,
                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                              size: 24,
                                                            ),
                                                            Container(
                                                              width: MediaQuery.of(context).size.width * 0.8,
                                                              decoration: BoxDecoration(
                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                                                child: Text(
                                                                  userData != null ? userData['specialisations'][index] : '',
                                                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
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
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                          ),
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            itemCount: userData != null ? userData['lgo'].length : 0,
                                            itemBuilder: (context, index) {
                                              return Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * 0.42,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Image.asset(
                                                          'assets/lgo/' + userData['lgo'][index]['image'],
                                                          width: 120,
                                                          height: 60,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * 0.4,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                    ),
                                                    child: LevelProgressBar(
                                                      level: userData['lgo'][index]['niveau'],
                                                    ),
                                                  )
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
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
                                              'Compétences',
                                              style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                    fontFamily: 'Poppins',
                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        if (userData['competences'].contains('Test COVID'))
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                                      child: Icon(
                                                        Icons.coronavirus,
                                                        color: Color(0xFF595A71),
                                                        size: 28,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Test COVID',
                                                      style: FlutterFlowTheme.of(context).bodyMedium,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (userData['competences'].contains('Vaccination'))
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                                        child: SvgPicture.asset(
                                                          'assets/icons/Vaccines.svg',
                                                          width: 24,
                                                          colorFilter: ColorFilter.mode(Color(0xFF595A71), BlendMode.srcIn),
                                                        )),
                                                    Text(
                                                      'Vaccination',
                                                      style: FlutterFlowTheme.of(context).bodyMedium,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (userData['competences'].contains('Gestion des tiers payant'))
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                                      child: Icon(
                                                        Icons.payments_outlined,
                                                        color: Color(0xFF595A71),
                                                        size: 28,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Gestion des tiers payant',
                                                      style: FlutterFlowTheme.of(context).bodyMedium,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (userData['competences'].contains('Gestion de laboratoire'))
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                                      child: Icon(
                                                        Icons.science_outlined,
                                                        color: Color(0xFF595A71),
                                                        size: 28,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Gestion de laboratoire',
                                                      style: FlutterFlowTheme.of(context).bodyMedium,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (userData['competences'].contains('TROD'))
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                                        child: SvgPicture.asset(
                                                          'assets/icons/labs.svg',
                                                          width: 27,
                                                          colorFilter: ColorFilter.mode(Color(0xFF595A71), BlendMode.srcIn),
                                                        )),
                                                    Text(
                                                      'TROD',
                                                      style: FlutterFlowTheme.of(context).bodyMedium,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
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
                                                    'Langues',
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
                                        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                          ),
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            itemCount: userData != null ? userData['langues'].length : 0,
                                            itemBuilder: (context, index) {
                                              return Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * 0.4,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Icon(
                                                          Icons.language_sharp,
                                                          color: Color(0xFF595A71),
                                                          size: 24,
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                                          child: Text(
                                                            userData['langues'][index]['name'],
                                                            overflow: TextOverflow.ellipsis,
                                                            style: FlutterFlowTheme.of(context).bodyMedium,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * 0.4,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                    ),
                                                    child: wrapWithModel(
                                                      model: _model.headerAppModel /*  _model.listSkillWithSliderModel2 */,
                                                      updateCallback: () => setState(() {}),
                                                      child: LevelProgressBar(
                                                        level: userData['langues'][index]['niveau'],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
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
                                              'Expériences',
                                              style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                    fontFamily: 'Poppins',
                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: userData != null ? userData['experiences'].length : 0,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                                    child: Icon(
                                                      Icons.work_outline,
                                                      color: Color(0xFF595A71),
                                                      size: 24,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * 0.6,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                    ),
                                                    child: Text(
                                                      userData['experiences'][index]['nom_pharmacie'] + ', ' + userData['experiences'][index]['annee_debut'] + '-' + userData['experiences'][index]['annee_fin'],
                                                      style: FlutterFlowTheme.of(context).bodyMedium,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_selectedIndex == 1)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Column(
                                children: [
                                  for (var i in networkUser) i['type'] == 'user' ? CardUserWidget(data: i) : CardPharmacieWidget(data: i),
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (_selectedIndex == 2 && recherchesUser.isNotEmpty)
                        for (var searchI in recherchesUser)
                          CardSearchProfilWidget(
                            searchI: searchI,
                            isEditable: false,
                          ),
                      if (_selectedIndex == 2 && offresUser.isNotEmpty)
                        for (var searchI in offresUser)
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
