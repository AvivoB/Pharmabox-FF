import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmabox/composants/card_offers_profile/card_offers_profile.dart';
import 'package:pharmabox/constant.dart';
import 'package:pharmabox/custom_code/widgets/progress_indicator.dart';
import 'package:pharmabox/custom_code/widgets/snackbar_message.dart';
import 'package:pharmabox/profil/profil_provider.dart';
import 'package:pharmabox/profil_pharmacie/profil_pharmacie_model.dart';
import 'package:pharmabox/profil_pharmacie/profil_pharmacie_provider.dart';

import '../composants/card_pharmacie/card_pharmacie_widget.dart';
import '../composants/card_user/card_user_widget.dart';
import '../composants/list_skill_with_slider/list_skill_with_slider_widget.dart';
import '../custom_code/widgets/carousel_pharmacie_slider_select_image.dart';
import '../custom_code/widgets/gradient_text_custom.dart';
import '../custom_code/widgets/horaire_select_widget.dart';
import '../custom_code/widgets/like_button.dart';
import '../custom_code/widgets/map_adresse_pharmacie.dart';
import '../custom_code/widgets/prediction_nom_pharmacie.dart';
import '../custom_code/widgets/slider_simple.dart';
import '../popups/popup_experiences/popup_experiences_widget.dart';
import '../popups/popup_groupement/popup_groupement_widget.dart';
import '../popups/popup_langues/popup_langues_widget.dart';
import '../popups/popup_lgo pharmacie/popup_lgo_pharmacie_widget.dart';
import '../popups/popup_lgo/popup_lgo_widget.dart';
import '../popups/popup_specialisation/popup_specialisation_widget.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/composants/header_app/header_app_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/popups/popup_profil/popup_profil_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
// import 'profil_model.dart';
// export 'profil_model.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

class ProfilPharmacie extends StatefulWidget {
  const ProfilPharmacie({Key? key}) : super(key: key);

  @override
  _ProfilPharmacieState createState() => _ProfilPharmacieState();
}

class _ProfilPharmacieState extends State<ProfilPharmacie> with SingleTickerProviderStateMixin {
  late PharmacieModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  var userData;
  List offresPharma = [];
  Map<String, dynamic> userTituData = {};
  bool isExpanded_Titu = false;
  bool isExpanded_NonTitu = false;
  bool isExpanded_Pharma = false;

  List titulairesNetwork = [];
  List nonTitulairesNetwork = [];
  List pharmaciesNetwork = [];
  bool _isLoading = false;

  String? countryCode;

  TabController? _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PharmacieModel());
    _tabController = TabController(length: 3, vsync: this);
    getUserData();

    _model.nomdelapharmacieController1 ??= TextEditingController();
    _model.nomdelapharmacieController2 ??= TextEditingController();
    _model.presentationController ??= TextEditingController();
    _model.emailPharmacieController ??= TextEditingController();
    _model.phonePharmacieController1 ??= TextEditingController();
    _model.pharmacieAdresseController ??= TextEditingController();
    _model.pharmacieAdressePostCode ??= TextEditingController();
    _model.pharmacieAdresseVille ??= TextEditingController();
    _model.pharmacieAdresseRegion ??= TextEditingController();
    _model.pharmacieAdresseArrondissement ??= TextEditingController();
    _model.pharmacieAdresseController ??= TextEditingController();
    _model.rerController ??= TextEditingController();
    _model.metroController ??= TextEditingController();
    _model.busController ??= TextEditingController();
    _model.tramwayController1 ??= TextEditingController();
    _model.tramwayController2 ??= TextEditingController();
    _model.nbPharmaciensController ??= TextEditingController();
    _model.nbPreparateurController ??= TextEditingController();
    _model.nbRayonnistesController ??= TextEditingController();
    _model.nbConseillersController ??= TextEditingController();
    _model.nbApprentiController ??= TextEditingController();
    _model.nbEtudiantsController ??= TextEditingController();
    _model.nbEtudiants6emeController ??= TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  Future<void> getNetworkData() async {
    String pharmacieID = userData != null ? userData['documentId'] : '';
    // Use collection group to make query across all collections
    QuerySnapshot queryUsers = await FirebaseFirestore.instance.collection('users').where('reseau', arrayContains: pharmacieID).get();

    QuerySnapshot queryPharmacies = await FirebaseFirestore.instance.collection('pharmacies').where('reseau', arrayContains: pharmacieID).get();

    for (var doc in queryPharmacies?.docs ?? []) {
      var data = doc.data();
      data['documentId'] = doc.id;
      pharmaciesNetwork.add(data);
    }

    // Split users based on their 'poste' field
    for (var doc in queryUsers.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data != null && data['poste'] == 'Pharmacien titulaire') {
        titulairesNetwork.add(data);
      } else {
        nonTitulairesNetwork.add(data);
      }
    }
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

    // Query query = FirebaseFirestore.instance.collection('pharmacies').where('user_id', isEqualTo: user.uid);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('pharmacies').where('user_id', isEqualTo: user.uid).get();
    QuerySnapshot offres = await FirebaseFirestore.instance.collection('offres').where('user_id', isEqualTo: user.uid).get();
    DocumentSnapshot utilisateurTitu = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    // Accéder aux données du document.
    var data = querySnapshot.docs;
    setState(() {
      for (var doc in data) {
        userData = doc.data();
        userData['documentId'] = doc.id;
      }
      for (var doc in offres.docs) {
        var docData = doc.data() as Map<String, dynamic>;

        docData['doc_id'] = doc.id;

        print(docData);
        offresPharma.add(docData);
      }

      userTituData = utilisateurTitu.data() as Map<String, dynamic>;
      print(userTituData['country']);
      countryCode = supportedCountry[userTituData['country']];
    });
    _model.imagePharmacie = userData != null ? List<String>.from(userData['photo_url']) : [];

    _model.nomdelapharmacieController1.text = userData != null ? userData['situation_geographique']['adresse'] : '';

    _model.nomdelapharmacieController2.text = userData != null ? userData['titulaire_principal'] : userTituData['nom'] + ' ' + userTituData['prenom'];
    _model.presentationController.text = userData != null ? userData['presentation'] : '';
    _model.emailPharmacieController.text = userData != null ? userData['contact_pharma']['email'] : userTituData['email'];
    _model.phonePharmacieController1.text = userData != null ? userData['contact_pharma']['telephone'] : '';
    _model.rerController.text = userData != null ? userData['accessibilite']['rer'] : '';
    _model.metroController.text = userData != null ? userData['accessibilite']['metro'] : '';
    _model.busController.text = userData != null ? userData['accessibilite']['bus'] : '';
    _model.tramwayController1.text = userData != null ? userData['accessibilite']['tram'] : '';
    _model.tramwayController2.text = userData != null ? userData['accessibilite']['gare'] : '';
    _model.parkingValue = userData != null ? userData['accessibilite']['stationnement'] : '';
    _model.nbPharmaciensController.text = userData != null ? userData['equipe']['nb_pharmaciens'] : '';
    _model.nbPreparateurController.text = userData != null ? userData['equipe']['nb_preparateurs'] : '';
    _model.nbRayonnistesController.text = userData != null ? userData['equipe']['nb_rayonnistes'] : '';
    _model.nbConseillersController.text = userData != null ? userData['equipe']['nb_conseillers'] : '';
    _model.nbApprentiController.text = userData != null ? userData['equipe']['nb_apprentis'] : '';
    _model.nbEtudiantsController.text = userData != null ? userData['equipe']['nb_etudiants'] : '';
    _model.nbEtudiants6emeController.text = userData != null ? userData['equipe']['nb_etudiants_6eme_annee'] : '';
    _model.nonSTOPValue = userData != null ? userData['Non-stop'] : false;
    _model.typologie = userData != null ? userData['typologie'] : '';
    _model.preferenceContactValue = userData != null ? userData['contact_pharma']['preference_contact'] : '';
    _model.patientParJourValue = userData != null ? userData['nb_patient_jour'] : '';
    setState(() {
      _isLoading = false;
    });
  }

  // Enregistrement dans la base
  updatePharmacie(context) async {
    final firestore = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;

    final CollectionReference<Map<String, dynamic>> pharmaciesRef = FirebaseFirestore.instance.collection('pharmacies');

    // String doc_id = '';
    // final Future<QuerySnapshot<Map<String, dynamic>>> pharmaciesQuery =
    //     FirebaseFirestore.instance
    //         .collection('pharmacies')
    //         .where('user_id', isEqualTo: userData['user_id'])
    //         .get();

    // // Attendre que la Future soit complétée
    // final QuerySnapshot<Map<String, dynamic>> snapshot = await pharmaciesQuery;

    // // Parcourir les documents
    // for (var doc in snapshot.docs) {
    //   doc_id = doc.id;
    // }

    final providerPharmacieUser = Provider.of<ProviderPharmacieUser>(context, listen: false);

    // if (_model.nomdelapharmacieController1.text == '') {
    //   showCustomSnackBar(
    //       context, 'Le nom de la pharmacie ne peut pas être vide',
    //       isError: true);
    //   return;
    // }

    List missions = [];
    if (_model.missioTestCovidValue) {
      missions.add('Test COVID');
    }
    if (_model.missionVaccinationValue) {
      missions.add('Vaccination');
    }
    if (_model.missionEnretienPharmaValue) {
      missions.add('Entretien pharmaceutique');
    }
    if (_model.missionsBorneValue) {
      missions.add('Borne de télé-médecine');
    }
    if (_model.missionPreparationValue) {
      missions.add('externalisé');
    } else {
      missions.add('par l\'équipe');
    }

    List confort = [];
    if (_model.confortSallePauseValue) {
      confort.add('Salle de pause');
    }
    if (_model.confortRobotValue) {
      confort.add('Robot');
    }
    if (_model.confortEtiquetteValue) {
      confort.add('Etiquettes éléctroniques');
    }
    if (_model.confortMonayeurValue) {
      confort.add('Monnayeur');
    } else {
      confort.add('Caisse classique');
    }
    if (_model.confortCimValue) {
      confort.add('Climatisation');
    }
    if (_model.confortChauffageValue) {
      confort.add('Chauffage');
    }
    if (_model.confortVigileValue) {
      confort.add('Vigile');
    }
    if (_model.confortComiteEntrepriseValue) {
      confort.add('Comité d\'entreprise');
    }
    pharmaciesRef
        .doc(currentUser?.uid)
        .set({
          'user_id': currentUser!.uid,
          'photo_url': _model.imagePharmacie,
          'name': providerPharmacieUser.selectedPharmacieAdresse,
          'presentation': _model.presentationController.text,
          'titulaire_principal': _model.nomdelapharmacieController2.text,
          // 'titulaires_autres': titulaires,
          'maitre_stage': _model.comptencesTestCovidValue,
          'contact_pharma': {
            'email': _model.emailPharmacieController.text,
            'telephone': _model.phonePharmacieController1.text,
            'preference_contact': _model.preferenceContactValue,
          },
          'situation_geographique': {
            'adresse': providerPharmacieUser.selectedPharmacieAdresseRue,
            'lat_lng': [providerPharmacieUser.selectedAdressePharma[0]['latitude'], providerPharmacieUser.selectedAdressePharma[0]['longitude']],
            'data': providerPharmacieUser.selectedAdressePharma[0],
          },
          'accessibilite': {'rer': _model.rerController.text, 'metro': _model.metroController.text, 'bus': _model.busController.text, 'tram': _model.tramwayController1.text, 'gare': _model.tramwayController2.text, 'stationnement': _model.parkingValue},
          'horaires': providerPharmacieUser.selectedHoraires,
          'Non-stop': _model.nonSTOPValue ?? false,
          'typologie': _model.typologie,
          'nb_patient_jour': _model.patientParJourValue,
          'lgo': providerPharmacieUser.selectedLgo,
          'groupement': providerPharmacieUser.selectedGroupement,
          'missions': providerPharmacieUser.selectedMissions,
          'confort': providerPharmacieUser.selectedConfort,
          'tendances': providerPharmacieUser.tendences,
          'equipe': {
            'nb_pharmaciens': (_model.nbPharmaciensController.text != '') ? _model.nbPharmaciensController.text : '0',
            'nb_preparateurs': (_model.nbPreparateursController.text != '') ? _model.nbPreparateursController.text : '0',
            'nb_rayonnistes': (_model.nbRayonnistesController.text != '') ? _model.nbRayonnistesController.text : '0',
            'nb_conseillers': (_model.nbConseillersController.text != '') ? _model.nbConseillersController.text : '0',
            'nb_apprentis': (_model.nbApprentiController.text != '') ? _model.nbApprentiController.text : '0',
            'nb_etudiants': (_model.nbEtudiantsController.text != '') ? _model.nbEtudiantsController.text : '0',
            'nb_etudiants_6eme_annee': (_model.nbEtudiants6emeController.text != '') ? _model.nbEtudiants6emeController.text : '0',
          }
        }, SetOptions(merge: true))
        .then((value) => showCustomSnackBar(context, 'Vos informations ont été enregistrés'))
        .catchError((error) => showCustomSnackBar(context, 'Erreur d\'enregistrement', isError: true));
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerPharmacieUser = Provider.of<ProviderPharmacieUser>(context);

    if (userData != null && userData['groupement'] != null) {
      providerPharmacieUser.setGroupement(userData['groupement']);
    }

    if (userData != null && userData['lgo'] != null) {
      providerPharmacieUser.setLGO(userData['lgo']);
    }
    providerPharmacieUser.setMissions(userData != null ? userData['missions'] : []);
    providerPharmacieUser.setConfort(userData != null ? userData['confort'] : []);
    providerPharmacieUser.setHoraire(userData != null ? userData['horaires'] : null);
    providerPharmacieUser.setPharmacieLocation(userData != null ? userData['situation_geographique']['lat_lng'][0] : '', userData != null ? userData['situation_geographique']['lat_lng'][1] : '');

    getNetworkData();
    if (_isLoading) {
      return Center(child: ProgressIndicatorPharmabox());
    } else {
      return Consumer<ProviderPharmacieUser>(builder: (context, userRegisterSate, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(0xFFEFF6F7),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CarouselPharmacieSliderSelect(
                      onImagesSelected: (urls) {
                        _model.imagePharmacie = urls;
                      },
                      initialImagesSelected: userData != null && userData['photo_url'] != '' ? userData['photo_url'].cast<String>() : null,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(25, 25, 25, 25),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Form(
                              key: _model.formKey,
                              autovalidateMode: AutovalidateMode.disabled,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: PredictionNomPhamracie(
                                          countryCode: countryCode ?? 'fr',
                                          initialValue: userData != null ? userData['situation_geographique']['adresse'] : '',
                                          onPlaceSelected: (adresse) {
                                            providerPharmacieUser.setAdresseRue(adresse);
                                          })),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                    child: TextFormField(
                                      textCapitalization: TextCapitalization.sentences,
                                      controller: _model.nomdelapharmacieController2,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Titulaire',
                                        hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFD0D1DE),
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).focusColor,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: FlutterFlowTheme.of(context).secondaryText,
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context).bodyMedium,
                                      validator: _model.nomdelapharmacieController2Validator.asValidator(context),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                    child: providerPharmacieUser.selectedGroupement[0]['image'] == 'Autre.jpg'
                                        ? Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.60,
                                                child: TextFormField(
                                                  textCapitalization: TextCapitalization.sentences,
                                                  controller: _model.groupementAutre,
                                                  initialValue: providerPharmacieUser.selectedGroupement[0]['name'],
                                                  onChanged: (value) {
                                                    providerPharmacieUser.selectGroupement({"name": "${value}", "image": "Autre.jpg"});
                                                  },
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    labelText: 'Votre groupement',
                                                    hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0xFFD0D1DE),
                                                        width: 1,
                                                      ),
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: FlutterFlowTheme.of(context).focusColor,
                                                        width: 1,
                                                      ),
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    errorBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0x00000000),
                                                        width: 1,
                                                      ),
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    focusedErrorBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0x00000000),
                                                        width: 1,
                                                      ),
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    prefixIcon: Icon(
                                                      Icons.group_work_outlined,
                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                    ),
                                                  ),
                                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                                ),
                                              ),
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                onTap: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor: Colors.transparent,
                                                    enableDrag: true,
                                                    context: context,
                                                    builder: (bottomSheetContext) {
                                                      return DraggableScrollableSheet(
                                                          initialChildSize: 0.75,
                                                          builder: (BuildContext context, ScrollController scrollController) {
                                                            return GestureDetector(
                                                              onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
                                                              child: Padding(
                                                                padding: MediaQuery.of(bottomSheetContext).viewInsets,
                                                                child: PopupGroupementWidget(onTap: (value) {
                                                                  var groupement = context.read<ProviderPharmacieUser>();
                                                                  groupement.selectGroupement(value);
                                                                }),
                                                              ),
                                                            );
                                                          });
                                                    },
                                                  ).then((value) => setState(() {}));
                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: 30,
                                                  child: GradientTextCustom(
                                                    width: 100,
                                                    height: 30,
                                                    text: 'Modifier',
                                                    radius: 0.0,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset(
                                                'assets/groupements/' + providerPharmacieUser.selectedGroupement[0]['image'],
                                                width: 120,
                                                height: 60,
                                                fit: BoxFit.contain,
                                              ),
                                              Container(
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Groupement',
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: 'Poppins',
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                    ),
                                                    Text(
                                                      providerPharmacieUser.selectedGroupement[0]['name'],
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: 'Poppins',
                                                            fontSize: 11,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                onTap: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor: Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (bottomSheetContext) {
                                                      return DraggableScrollableSheet(
                                                        initialChildSize: 0.75,
                                                        builder: (BuildContext context, ScrollController scrollController) {
                                                        return GestureDetector(
                                                          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
                                                          child: Padding(
                                                            padding: MediaQuery.of(bottomSheetContext).viewInsets,
                                                            child: PopupGroupementWidget(onTap: (value) {
                                                              providerPharmacieUser.selectGroupement(value);
                                                            }),
                                                          ),
                                                        );
                                                      });
                                                    },
                                                  ).then((value) => setState(() {}));
                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: 30,
                                                  child: GradientTextCustom(
                                                    width: 100,
                                                    height: 30,
                                                    text: 'Modifier',
                                                    radius: 0.0,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                    child: TextFormField(
                                      textCapitalization: TextCapitalization.sentences,
                                      controller: _model.presentationController,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Présentation',
                                        hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFD0D1DE),
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).focusColor,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context).bodyMedium,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      validator: _model.presentationControllerValidator.asValidator(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                      Container(
                          child: Column(children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                          child: Container(
                            width: double.infinity,
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
                              width: 100,
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
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Contact pharmacie',
                                            style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                  fontFamily: 'Poppins',
                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: TextFormField(
                                        controller: _model.emailPharmacieController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                          hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).focusColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.mail_outlined,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                        keyboardType: TextInputType.emailAddress,
                                        validator: _model.emailPharmacieControllerValidator.asValidator(context),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: TextFormField(
                                        controller: _model.phonePharmacieController1,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Téléphone',
                                          hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).focusColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.local_phone,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                        keyboardType: TextInputType.phone,
                                        validator: _model.phonePharmacieController1Validator.asValidator(context),
                                        // inputFormatters: [_model.phonePharmacieMask1],
                                      ),
                                    ),
                                    Text('Séléctionnez si vous souhaitez être contacté via les infos de contact de la pharmacie ou de votre profil.', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 12)),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: Color(0xFFD0D1DE),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                              child: Icon(
                                                Icons.settings_outlined,
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                size: 24,
                                              ),
                                            ),
                                            FlutterFlowDropDown<String>(
                                              controller: _model.preferenceContactValueController ??= FormFieldController<String>(_model.preferenceContactValue),
                                              options: ['Personnel', 'Pharmacie'],
                                              onChanged: (val) => setState(() => _model.preferenceContactValue = val),
                                              width: MediaQuery.of(context).size.width * 0.75,
                                              height: 50,
                                              textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.black,
                                                  ),
                                              hintText: 'Préférences de contact',
                                              fillColor: Colors.white,
                                              elevation: 2,
                                              borderColor: Colors.transparent,
                                              borderWidth: 0,
                                              borderRadius: 0,
                                              margin: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
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
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                          child: Container(
                            width: double.infinity,
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
                            child: Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                borderRadius: BorderRadius.circular(15),
                                shape: BoxShape.rectangle,
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                      child: Row(
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
                                    ),
                                    MapAdressePharmacie(
                                        countryCode: countryCode ?? 'fr',
                                        onInitialValue: userData != null ? userData['situation_geographique']['data']['rue'] + ', ' + userData['situation_geographique']['data']['ville'] + ', ' + userData['situation_geographique']['data']['postcode'] + ', ' + userData['situation_geographique']['data']['country'] : '',
                                        onAdressSelected: (latitude, longitude, adresse, postcode, ville, arrondissement, region, country) {
                                          _model.pharmacieAdresseController.text = adresse;
                                          providerPharmacieUser.setAdresse(latitude, longitude, postcode, adresse, ville, region, arrondissement, country);
                                        })
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                          child: Container(
                            width: double.infinity,
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
                            child: Container(
                              width: 100,
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
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                          child: Text(
                                            'Accessibilité',
                                            style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                  fontFamily: 'Poppins',
                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.sentences,
                                        controller: _model.rerController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'RER',
                                          hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).focusColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.train,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                        validator: _model.rerControllerValidator.asValidator(context),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.sentences,
                                        controller: _model.metroController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Métro',
                                          hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).focusColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.subway_outlined,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                        validator: _model.metroControllerValidator.asValidator(context),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.sentences,
                                        controller: _model.busController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Bus',
                                          hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).focusColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.directions_bus_outlined,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                        validator: _model.busControllerValidator.asValidator(context),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.sentences,
                                        controller: _model.tramwayController1,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Tramway',
                                          hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).focusColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.tram_outlined,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                        validator: _model.tramwayController1Validator.asValidator(context),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.sentences,
                                        controller: _model.tramwayController2,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Gare',
                                          hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).focusColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.directions_bus_sharp,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                        validator: _model.tramwayController2Validator.asValidator(context),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: Color(0xFFD0D1DE),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                              child: Icon(
                                                Icons.local_parking,
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                size: 24,
                                              ),
                                            ),
                                            FlutterFlowDropDown<String>(
                                              controller: _model.parkingValueController ??= FormFieldController<String>(_model.parkingValue ?? ''),
                                              options: ['Gratuit', 'Payant'],
                                              onChanged: (val) => setState(() => _model.parkingValue = val),
                                              width: MediaQuery.of(context).size.width * 0.73,
                                              height: 50,
                                              textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.black,
                                                  ),
                                              hintText: 'Stationnement',
                                              fillColor: Colors.white,
                                              elevation: 2,
                                              borderColor: Colors.transparent,
                                              borderWidth: 0,
                                              borderRadius: 0,
                                              margin: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
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
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                          child: Container(
                            width: double.infinity,
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
                            child: Container(
                              width: 100,
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
                                                    'assets/icons/24H.svg',
                                                    width: 24,
                                                    colorFilter: ColorFilter.mode(Color(0xFF595A71), BlendMode.srcIn),
                                                  )),
                                              Text(
                                                'Non stop',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Switch.adaptive(
                                            value: _model.nonSTOPValue ??= false,
                                            onChanged: (newValue) async {
                                              setState(() => _model.nonSTOPValue = newValue);
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (_model.nonSTOPValue == false)
                                      HorraireSemaineSelect(
                                        callback: (listHoraire) {
                                          providerPharmacieUser.setHoraire(listHoraire);
                                        },
                                        initialHours: providerPharmacieUser.selectedHoraires,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                          child: Container(
                            width: double.infinity,
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
                            child: Container(
                              width: 100,
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
                                                  Icons.store_outlined,
                                                  color: Color(0xFF595A71),
                                                  size: 28,
                                                ),
                                              ),
                                              Text(
                                                'Centre commercial',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Switch.adaptive(
                                            value: _model.typologie == 'Centre commercial' ? true : false,
                                            onChanged: (newValue) async {
                                              setState(() => _model.typologie = 'Centre commercial');
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                                  Icons.apartment,
                                                  color: Color(0xFF595A71),
                                                  size: 28,
                                                ),
                                              ),
                                              Text(
                                                'Centre ville',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Switch.adaptive(
                                            value: _model.typologie == 'Centre ville' ? true : false,
                                            onChanged: (newValue) async {
                                              setState(() => _model.typologie = 'Centre ville');
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                                  Icons.flight_takeoff,
                                                  color: Color(0xFF595A71),
                                                  size: 28,
                                                ),
                                              ),
                                              Text(
                                                'Aéroport',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Switch.adaptive(
                                            value: _model.typologie == 'Aéroport' ? true : false,
                                            onChanged: (newValue) async {
                                              setState(() => _model.typologie = 'Aéroport');
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                                  Icons.directions_bus,
                                                  color: Color(0xFF595A71),
                                                  size: 28,
                                                ),
                                              ),
                                              Text(
                                                'Gare',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Switch.adaptive(
                                            value: _model.typologie == 'Gare' ? true : false,
                                            onChanged: (newValue) async {
                                              setState(() => _model.typologie = 'Gare');
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                                    'assets/icons/quartier.svg',
                                                    colorFilter: ColorFilter.mode(Color(0xFF595A71), BlendMode.srcIn),
                                                  )),
                                              Text(
                                                'Quartier',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Switch.adaptive(
                                            value: _model.typologie == 'Quartier' ? true : false,
                                            onChanged: (newValue) async {
                                              setState(() => _model.typologie = 'Quartier');
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                                  Icons.landscape_outlined,
                                                  color: Color(0xFF595A71),
                                                  size: 28,
                                                ),
                                              ),
                                              Text(
                                                'Lieu touristique',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Switch.adaptive(
                                            value: _model.typologie == 'Lieu touristique' ? true : false,
                                            onChanged: (newValue) async {
                                              setState(() => _model.typologie = 'Lieu touristique');
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                                  Icons.nature_people_outlined,
                                                  color: Color(0xFF595A71),
                                                  size: 28,
                                                ),
                                              ),
                                              Text(
                                                'Zone rurale',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Switch.adaptive(
                                            value: _model.typologie == 'Zone rurale' ? true : false,
                                            onChanged: (newValue) async {
                                              setState(() => _model.typologie = 'Zone rurale');
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: Color(0xFFD0D1DE),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                              child: Icon(
                                                Icons.group,
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                size: 24,
                                              ),
                                            ),
                                            FlutterFlowDropDown<String>(
                                              controller: _model.patientParJourValueController ??= FormFieldController<String>(_model.patientParJourValue),
                                              options: ['<100 ', '100-250', '250-400', '>400'],
                                              onChanged: (val) => setState(() => _model.patientParJourValue = val),
                                              width: MediaQuery.of(context).size.width * 0.72,
                                              height: 50,
                                              textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.black,
                                                  ),
                                              hintText: 'Nombre de patients par jour',
                                              fillColor: Colors.white,
                                              elevation: 2,
                                              borderColor: Colors.transparent,
                                              borderWidth: 0,
                                              borderRadius: 0,
                                              margin: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
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
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                          child: Container(
                            width: double.infinity,
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
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              onTap: () async {
                                                await showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  backgroundColor: Colors.transparent,
                                                  enableDrag: false,
                                                  context: context,
                                                  builder: (bottomSheetContext) {
                                                    return DraggableScrollableSheet(
                                                        initialChildSize: 0.80,
                                                        builder: (BuildContext context, ScrollController scrollController, {initialChildSize: 0.8}) {
                                                          return GestureDetector(
                                                            onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
                                                            child: Padding(
                                                              padding: MediaQuery.of(bottomSheetContext).viewInsets,
                                                              child: PopupLgoWidget(
                                                                onTap: (lgo) {
                                                                  providerPharmacieUser.selectLGO(lgo);
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                ).then((value) => setState(() {}));
                                              },
                                              child: Container(
                                                width: 100,
                                                height: 30,
                                                child: GradientTextCustom(
                                                  width: 100,
                                                  height: 30,
                                                  text: 'Ajouter',
                                                  radius: 0.0,
                                                  fontSize: 12.0,
                                                ),
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
                                    child: ListView(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      children: [
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
                                                    'assets/lgo/' + providerPharmacieUser.selectedLgo[0]['image'],
                                                    width: 120,
                                                    height: 60,
                                                    fit: BoxFit.contain,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                                    child: Text(
                                                      providerPharmacieUser.selectedLgo[0]['name'],
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
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                          child: Container(
                            width: double.infinity,
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
                            child: Container(
                              width: 100,
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
                                          Switch.adaptive(
                                            value: providerPharmacieUser.selectedMissions.contains('Test COVID') ? true : false,
                                            onChanged: (newValue) async {
                                              setState(() => providerPharmacieUser.updateMissions(newValue, 'Test COVID'));
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                                    width: 20,
                                                    colorFilter: ColorFilter.mode(Color(0xFF595A71), BlendMode.srcIn),
                                                  )),
                                              Text(
                                                'Vaccination',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Switch.adaptive(
                                            value: providerPharmacieUser.selectedMissions.contains('Vaccination') ? true : false,
                                            onChanged: (newValue) async {
                                              setState(() => providerPharmacieUser.updateMissions(newValue, 'Vaccination'));
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                                    'assets/icons/Entretien.svg',
                                                    width: 20,
                                                    colorFilter: ColorFilter.mode(Color(0xFF595A71), BlendMode.srcIn),
                                                  )),
                                              Text(
                                                'Entretien pharmaceutique',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Switch.adaptive(
                                            value: providerPharmacieUser.selectedMissions.contains('Entretien pharmaceutique') ? true : false,
                                            onChanged: (newValue) async {
                                              setState(() => providerPharmacieUser.updateMissions(newValue, 'Entretien pharmaceutique'));
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                                  Icons.videocam_outlined,
                                                  color: Color(0xFF595A71),
                                                  size: 28,
                                                ),
                                              ),
                                              Text(
                                                'Borne de télé-médecine',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Switch.adaptive(
                                            value: providerPharmacieUser.selectedMissions.contains('Borne de télé-médecine') ? true : false,
                                            onChanged: (newValue) async {
                                              setState(() => providerPharmacieUser.updateMissions(newValue, 'Borne de télé-médecine'));
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                                  Icons.local_pharmacy_outlined,
                                                  color: Color(0xFF595A71),
                                                  size: 28,
                                                ),
                                              ),
                                              Text(
                                                'Préparation externalisé',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              )
                                            ],
                                          ),
                                          Switch.adaptive(
                                            value: providerPharmacieUser.selectedMissions.contains('Préparation externalisé') ? true : false,
                                            onChanged: (newValue) async {
                                              setState(() => providerPharmacieUser.updateMissions(newValue, 'Préparation externalisé'));
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                          child: Container(
                            width: double.infinity,
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
                            child: Container(
                              width: 100,
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
                                                  child: SvgPicture.asset(
                                                    'assets/icons/Pause.svg',
                                                    width: 20,
                                                    colorFilter: ColorFilter.mode(Color(0xFF595A71), BlendMode.srcIn),
                                                  )),
                                              Text(
                                                'Salle de pause',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Switch.adaptive(
                                            value: providerPharmacieUser.selectedConfort.contains('Salle de pause') ? true : false,
                                            onChanged: (newValue) async {
                                              setState(() => providerPharmacieUser.updateConfort(newValue, 'Salle de pause'));
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                                    'assets/icons/Bot.svg',
                                                    width: 22,
                                                    colorFilter: ColorFilter.mode(Color(0xFF595A71), BlendMode.srcIn),
                                                  )),
                                              Text(
                                                'Robot',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Switch.adaptive(
                                            value: providerPharmacieUser.selectedConfort.contains('Robot') ? true : false,
                                            onChanged: (newValue) async {
                                              setState(() => providerPharmacieUser.updateConfort(newValue, 'Robot'));
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                                    'assets/icons/qrcode.svg',
                                                    width: 20,
                                                    colorFilter: ColorFilter.mode(Color(0xFF595A71), BlendMode.srcIn),
                                                  )),
                                              Text(
                                                'Étiquettes électroniques',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Switch.adaptive(
                                            value: providerPharmacieUser.selectedConfort.contains('Étiquettes électroniques') ? true : false,
                                            onChanged: (newValue) async {
                                              setState(() => providerPharmacieUser.updateConfort(newValue, 'Étiquettes électroniques'));
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                                    'assets/icons/moneyeur.svg',
                                                    width: 24,
                                                    colorFilter: ColorFilter.mode(Color(0xFF595A71), BlendMode.srcIn),
                                                  )),
                                              Text(
                                                'Monnayeur',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              )
                                            ],
                                          ),
                                          Switch.adaptive(
                                            value: providerPharmacieUser.selectedConfort.contains('Monnayeur') ? true : false,
                                            onChanged: (newValue) async {
                                              setState(() => providerPharmacieUser.updateConfort(newValue, 'Monnayeur'));
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                                    'assets/icons/clim.svg',
                                                    width: 24,
                                                    colorFilter: ColorFilter.mode(Color(0xFF595A71), BlendMode.srcIn),
                                                  )),
                                              Text(
                                                'Climatisation',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Switch.adaptive(
                                            value: providerPharmacieUser.selectedConfort.contains('Climatisation') ? true : false,
                                            onChanged: (newValue) async {
                                              setState(() => providerPharmacieUser.updateConfort(newValue, 'Climatisation'));
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                                    'assets/icons/chauffage.svg',
                                                    width: 24,
                                                    colorFilter: ColorFilter.mode(Color(0xFF595A71), BlendMode.srcIn),
                                                  )),
                                              Text(
                                                'Chauffage',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Switch.adaptive(
                                            value: providerPharmacieUser.selectedConfort.contains('Chauffage') ? true : false,
                                            onChanged: (newValue) async {
                                              setState(() => providerPharmacieUser.updateConfort(newValue, 'Chauffage'));
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                                    'assets/icons/vigile.svg',
                                                    width: 24,
                                                    colorFilter: ColorFilter.mode(Color(0xFF595A71), BlendMode.srcIn),
                                                  )),
                                              Text(
                                                'Vigile',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Switch.adaptive(
                                            value: providerPharmacieUser.selectedConfort.contains('Vigile') ? true : false,
                                            onChanged: (newValue) async {
                                              setState(() => providerPharmacieUser.updateConfort(newValue, 'Vigile'));
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                                    'assets/icons/Groups.svg',
                                                    width: 24,
                                                    colorFilter: ColorFilter.mode(Color(0xFF595A71), BlendMode.srcIn),
                                                  )),
                                              Text(
                                                'Comité d\'entreprise',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Switch.adaptive(
                                            value: providerPharmacieUser.selectedConfort.contains('Comité d\'entreprise') ? true : false,
                                            onChanged: (newValue) async {
                                              setState(() => providerPharmacieUser.updateConfort(newValue, 'Comité d\'entreprise'));
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                          child: Container(
                            width: double.infinity,
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
                            child: Container(
                              width: 100,
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
                                                  child: SvgPicture.asset(
                                                    'assets/icons/ordonances.svg',
                                                    width: 24,
                                                    colorFilter: ColorFilter.mode(Color(0xFF595A71), BlendMode.srcIn),
                                                  )),
                                              Text(
                                                'Ordonances',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Container(
                                              width: MediaQuery.of(context).size.width * 0.4,
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                              ),
                                              child: SliderSimple(
                                                  slider: userData != null ? userData['tendances'][0]['Ordonances'] : 1,
                                                  onChanged: (value) {
                                                    providerPharmacieUser.setTendences(0, 'Ordonances', value);
                                                  })),
                                        ],
                                      ),
                                    ),
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
                                                    'assets/icons/bebe.svg',
                                                    width: 24,
                                                    colorFilter: ColorFilter.mode(Color(0xFF595A71), BlendMode.srcIn),
                                                  )),
                                              Text(
                                                'Cosmétiques',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Container(
                                              width: MediaQuery.of(context).size.width * 0.4,
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                              ),
                                              child: SliderSimple(
                                                slider: userData != null ? userData['tendances'][0]['Cosmétiques'] : 1,
                                                onChanged: (value) {
                                                  providerPharmacieUser.setTendences(1, 'Cosmétiques', value);
                                                },
                                              )),
                                        ],
                                      ),
                                    ),
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
                                                    'assets/icons/phyto.svg',
                                                    width: 24,
                                                    colorFilter: ColorFilter.mode(Color(0xFF595A71), BlendMode.srcIn),
                                                  )),
                                              Text(
                                                'Phyto / aroma',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Container(
                                              width: MediaQuery.of(context).size.width * 0.4,
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                              ),
                                              child: SliderSimple(
                                                  slider: userData != null ? userData['tendances'][0]['Phyto / aroma'] : 1,
                                                  onChanged: (value) {
                                                    providerPharmacieUser.setTendences(2, 'Phyto / aroma', value);
                                                  })),
                                        ],
                                      ),
                                    ),
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
                                                    'assets/icons/nutrition.svg',
                                                    width: 24,
                                                    colorFilter: ColorFilter.mode(Color(0xFF595A71), BlendMode.srcIn),
                                                  )),
                                              Text(
                                                'Nutrition',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Container(
                                              width: MediaQuery.of(context).size.width * 0.4,
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                              ),
                                              child: SliderSimple(
                                                  slider: userData != null ? userData['tendances'][0]['Nutrition'] : 1,
                                                  onChanged: (value) {
                                                    providerPharmacieUser.setTendences(3, 'Nutrition', value);
                                                  })),
                                        ],
                                      ),
                                    ),
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
                                                    'assets/icons/question.svg',
                                                    width: 22,
                                                    colorFilter: ColorFilter.mode(Color(0xFF595A71), BlendMode.srcIn),
                                                  )),
                                              Text(
                                                'Conseil',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                          Container(
                                              width: MediaQuery.of(context).size.width * 0.4,
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                              ),
                                              child: SliderSimple(
                                                  slider: userData != null ? userData['tendances'][0]['Conseil'] : 1,
                                                  onChanged: (value) {
                                                    providerPharmacieUser.setTendences(4, 'Conseil', value);
                                                  })),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                          child: Container(
                            width: double.infinity,
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
                              width: 100,
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
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Notre équipe',
                                            style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                  fontFamily: 'Poppins',
                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: TextFormField(
                                        controller: _model.nbPharmaciensController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Nombre de pharmaciens',
                                          hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).focusColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.groups_2,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                        keyboardType: TextInputType.number,
                                        validator: _model.nbPharmaciensControllerValidator.asValidator(context),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: TextFormField(
                                        controller: _model.nbPreparateurController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Nombre de préparateurs',
                                          hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).focusColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.groups_2,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                        keyboardType: TextInputType.number,
                                        validator: _model.nbPreparateurControllerValidator.asValidator(context),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: TextFormField(
                                        controller: _model.nbRayonnistesController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Nombre de rayonnistes',
                                          hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).focusColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.groups_2,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                        keyboardType: TextInputType.number,
                                        validator: _model.nbRayonnistesControllerValidator.asValidator(context),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: TextFormField(
                                        controller: _model.nbConseillersController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Nombre de conseillers',
                                          hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).focusColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.groups_2,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                        keyboardType: TextInputType.number,
                                        validator: _model.nbConseillersControllerValidator.asValidator(context),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: TextFormField(
                                        controller: _model.nbApprentiController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Nombre d\'apprentis',
                                          hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).focusColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.groups_2,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                        keyboardType: TextInputType.number,
                                        validator: _model.nbApprentiControllerValidator.asValidator(context),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: TextFormField(
                                        controller: _model.nbEtudiantsController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Nombre d\'étudiants pharmacie',
                                          hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).focusColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.groups_2,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                        keyboardType: TextInputType.number,
                                        validator: _model.nbEtudiantsControllerValidator.asValidator(context),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: TextFormField(
                                        controller: _model.nbEtudiants6emeController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Nombre d\'étudiants 6ème année',
                                          hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).focusColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.groups_2,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                        keyboardType: TextInputType.number,
                                        validator: _model.nbEtudiants6emeControllerValidator.asValidator(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Color(0x301F5C67),
                                  offset: Offset(0, 4),
                                )
                              ],
                              gradient: LinearGradient(
                                colors: [Color(0xFF7CEDAC), Color(0xFF42D2FF)],
                                stops: [0, 1],
                                begin: AlignmentDirectional(1, -1),
                                end: AlignmentDirectional(-1, 1),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: FFButtonWidget(
                              onPressed: () async {
                                await Future.delayed(Duration(seconds: 2));
                                updatePharmacie(context);
                              },
                              text: 'Enregistrer',
                              options: FFButtonOptions(
                                elevation: 0,
                                width: double.infinity,
                                height: 40,
                                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                color: Color(0x00FFFFFF),
                                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ])),
                    if (_selectedIndex == 1 && offresPharma.isNotEmpty)
                      for (var searchI in offresPharma)
                        CardOfferProfilWidget(
                          searchI: searchI,
                        )
                  ],
                ),
              ),
            ),
          ),
        );
      });
    }
  }
}
