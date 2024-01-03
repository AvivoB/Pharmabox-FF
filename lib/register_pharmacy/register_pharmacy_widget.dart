import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmabox/constant.dart';
import 'package:pharmabox/register_pharmacy/register_pharmacie_provider.dart';

import '../custom_code/widgets/horaire_select_widget.dart';
import '../popups/popup_lgo pharmacie/popup_lgo_pharmacie_widget.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import '/popups/popup_groupement/popup_groupement_widget.dart';
import '/popups/popup_lgo/popup_lgo_widget.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'register_pharmacy_model.dart';
export 'register_pharmacy_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterPharmacyWidget extends StatefulWidget {
  RegisterPharmacyWidget({Key? key, this.titulaire, this.countryCode = 'fr'}) : super(key: key);
  String? titulaire;
  String? countryCode;

  @override
  _RegisterPharmacyWidgetState createState() => _RegisterPharmacyWidgetState();
}

class _RegisterPharmacyWidgetState extends State<RegisterPharmacyWidget> {
  late RegisterPharmacyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  String typologie = '';
  String? adressePharma;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RegisterPharmacyModel());

    _model.nomdelapharmacieController1 ??= TextEditingController();
    _model.nomdelapharmacieController2 ??= TextEditingController(text: widget.titulaire);
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
    _model.phonePharmacieController2 ??= TextEditingController();
    _model.nbPreparateurController ??= TextEditingController();
    _model.nbRayonnistesController ??= TextEditingController();
    _model.nbConseillersController ??= TextEditingController();
    _model.nbApprentiController ??= TextEditingController();
    _model.nbEtudiantsController ??= TextEditingController();
    _model.nbEtudiants6emeController ??= TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  final firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  // Enregistrement dans la base
  createPharmacie(context) {
    final CollectionReference<Map<String, dynamic>> pharmaciesRef = FirebaseFirestore.instance.collection('pharmacies');
    final providerPharmacieRegister = Provider.of<ProviderPharmacieRegister>(context, listen: false);

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
      missions.add('Préparation externalisé');
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

    pharmaciesRef.doc(currentUser?.uid).set({
      'user_id': currentUser!.uid,
      'photo_url': _model.imagePharmacie,
      'name': providerPharmacieRegister.selectedPharmacieAdresse,
      'presentation': _model.presentationController.text,
      'titulaire_principal': _model.nomdelapharmacieController2.text,
      'contact_pharma': {
        'email': _model.emailPharmacieController.text,
        'telephone': _model.phonePharmacieController1.text,
      },
      'situation_geographique': {
        'adresse': providerPharmacieRegister.selectedPharmacieAdresseRue,
        'lat_lng': providerPharmacieRegister.selectedPharmacieLocation,
        "data": providerPharmacieRegister.selectedAdressePharma[0],
      },
      'accessibilite': {'rer': _model.rerController.text, 'metro': _model.metroController.text, 'bus': _model.busController.text, 'tram': _model.tramwayController1.text, 'gare': _model.tramwayController2.text, 'stationnement': _model.parkingValue},
      'horaires': providerPharmacieRegister.selectedHoraires,
      'Non-stop': (_model.nonSTOPValue) ? true : false,
      'typologie': typologie,
      'nb_patient_jour': _model.patientParJourValue,
      'lgo': providerPharmacieRegister.selectedLgo,
      'groupement': providerPharmacieRegister.selectedGroupement,
      'missions': missions,
      'confort': confort,
      'tendances': providerPharmacieRegister.tendences,
      'equipe': {
        'nb_pharmaciens': (_model.phonePharmacieController2.text != '') ? _model.phonePharmacieController2.text : '0',
        'nb_preparateurs': (_model.nbPreparateurController.text != '') ? _model.nbPreparateurController.text : '0',
        'nb_rayonnistes': (_model.nbRayonnistesController.text != '') ? _model.nbRayonnistesController.text : '0',
        'nb_conseillers': (_model.nbConseillersController.text != '') ? _model.nbConseillersController.text : '0',
        'nb_apprentis': (_model.nbApprentiController.text != '') ? _model.nbApprentiController.text : '0',
        'nb_etudiants': (_model.nbEtudiantsController.text != '') ? _model.nbEtudiantsController.text : '0',
        'nb_etudiants_6eme_annee': (_model.nbEtudiants6emeController.text != '') ? _model.nbEtudiants6emeController.text : '0',
      },
      'isComplete': true,
      'isValid': true,
      'preference_contact': 'Pharmacie',
    });
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var widget_context_provider = context;

    final providerPharmacieRegister = Provider.of<ProviderPharmacieRegister>(context);

    return Consumer<ProviderPharmacieRegister>(builder: (context, userRegisterSate, child) {
      return WillPopScope(
        onWillPop: () async {
          // Retourner 'false' pour empêcher le retour en arrière
          return Future.value(false);
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(0xFFEFF6F7),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    custom_widgets.CarouselPharmacieSliderSelect(
                      onImagesSelected: (urls) {
                        _model.imagePharmacie = urls;
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(25, 10, 25, 10),
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
                                      child: custom_widgets.PredictionNomPhamracie(
                                        countryCode: supportedCountry[widget.countryCode.toString()].toString(),
                                        onPlaceSelected: (nomPharma) {
                                          providerPharmacieRegister.setAdresseRue(nomPharma);
                                        },
                                        onAdressSelected: (adresse) {
                                          setState(() {
                                            providerPharmacieRegister.setAdresseFromName(adresse);
                                          });
                                        },
                                      )),
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
                                    child: providerPharmacieRegister.selectedGroupement[0]['image'] != 'Autre.jpg'
                                        ? Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset(
                                                'assets/groupements/' + providerPharmacieRegister.selectedGroupement[0]['image'],
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
                                                      providerPharmacieRegister.selectedGroupement[0]['name'],
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
                                                                  print(value);
                                                                  var groupement = context.read<ProviderPharmacieRegister>();
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
                                                  child: custom_widgets.GradientTextCustom(
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
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.60,
                                                child: TextFormField(
                                                  textCapitalization: TextCapitalization.sentences,
                                                  controller: _model.groupementAutre,
                                                  onChanged: (value) {
                                                    print('Groupement selected' + value.toString());
                                                    providerPharmacieRegister.selectGroupement({"name": "${value}", "image": "Autre.jpg"});
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
                                                                var groupement = context.read<ProviderPharmacieRegister>();
                                                                groupement.selectGroupement(value);
                                                              }),
                                                            ),
                                                          );
                                                        }
                                                      );
                                                    },
                                                  ).then((value) => setState(() {}));
                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: 30,
                                                  child: custom_widgets.GradientTextCustom(
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
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
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
                                    // inputFormatters: [_model.phonePharmacieMask1]
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
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
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
                                custom_widgets.MapAdressePharmacie(
                                    countryCode: supportedCountry[widget.countryCode.toString()].toString(),
                                    onAdressSelected: (latitude, longitude, adresse, postcode, ville, arrondissement, region, country) {
                                      _model.pharmacieAdresseController.text = adresse;
                                      providerPharmacieRegister.setAdresse(postcode, adresse, ville, region, arrondissement, country);
                                    },
                                    onInitialValue: providerPharmacieRegister.selectedAdressFromName)
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
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
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
                                          controller: _model.parkingValueController ??= FormFieldController<String>(null),
                                          options: ['Gratuit ', 'Payant'],
                                          onChanged: (val) => setState(() => _model.parkingValue = val),
                                          width: MediaQuery.of(context).size.width * 0.75,
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
                                      providerPharmacieRegister.setHoraire(listHoraire);
                                    },
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
                                        value: typologie == 'Centre commercial' ? true : false,
                                        onChanged: (newValue) async {
                                          setState(() => _model.typologieCentrecommercialValue = newValue);
                                          typologie = 'Centre commercial';
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
                                        value: typologie == 'Centre ville' ? true : false,
                                        onChanged: (newValue) async {
                                          setState(() => _model.typologieCentrevilleValue = newValue);
                                          typologie = 'Centre ville';
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
                                        value: typologie == 'Aéroport' ? true : false,
                                        onChanged: (newValue) async {
                                          setState(() => _model.typologieAeroportValue = newValue);
                                          typologie = 'Aéroport';
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
                                        value: typologie == 'Gare' ? true : false,
                                        onChanged: (newValue) async {
                                          setState(() => _model.comptencesLaboValue1 = newValue);
                                          typologie = 'Gare';
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
                                        value: typologie == 'Quartier' ? true : false,
                                        onChanged: (newValue) async {
                                          setState(() => _model.comptencesLaboValue2 = newValue);
                                          typologie = 'Quartier';
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
                                        value: typologie == 'Lieu touristique' ? true : false,
                                        onChanged: (newValue) async {
                                          setState(() => _model.comptencesLaboValue3 = newValue);
                                          typologie = 'Lieu touristique';
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
                                        value: typologie == 'Zone rurale' ? true : false,
                                        onChanged: (newValue) async {
                                          setState(() => _model.comptencesTRODValue = newValue);
                                          typologie = 'Zone rurale';
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
                                          controller: _model.patientParJourValueController ??= FormFieldController<String>(null),
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
                                              enableDrag: true,
                                              context: context,
                                              builder: (bottomSheetContext) {
                                                return GestureDetector(
                                                  onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
                                                  child: Padding(
                                                    padding: MediaQuery.of(bottomSheetContext).viewInsets,
                                                    child: PopupLgoWidget(onTap: (lgo) {
                                                      providerPharmacieRegister.selectLGO(lgo);
                                                    }),
                                                  ),
                                                );
                                              },
                                            ).then((value) => setState(() {}));
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 30,
                                            child: custom_widgets.GradientTextCustom(
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
                                                'assets/lgo/' + providerPharmacieRegister.selectedLgo[0]['image'],
                                                width: 120,
                                                height: 60,
                                                fit: BoxFit.contain,
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                                child: Text(
                                                  providerPharmacieRegister.selectedLgo[0]['name'],
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
                                        value: _model.missioTestCovidValue ??= false,
                                        onChanged: (newValue) async {
                                          setState(() => _model.missioTestCovidValue = newValue);
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
                                        value: _model.missionVaccinationValue ??= false,
                                        onChanged: (newValue) async {
                                          setState(() => _model.missionVaccinationValue = newValue);
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
                                        value: _model.missionEnretienPharmaValue ??= false,
                                        onChanged: (newValue) async {
                                          setState(() => _model.missionEnretienPharmaValue = newValue);
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
                                        value: _model.missionsBorneValue ??= false,
                                        onChanged: (newValue) async {
                                          setState(() => _model.missionsBorneValue = newValue);
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
                                        value: _model.missionPreparationValue,
                                        onChanged: (newValue) async {
                                          setState(() => _model.missionPreparationValue = newValue);
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
                                        value: _model.confortSallePauseValue ??= false,
                                        onChanged: (newValue) async {
                                          setState(() => _model.confortSallePauseValue = newValue);
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
                                        value: _model.confortRobotValue ??= false,
                                        onChanged: (newValue) async {
                                          setState(() => _model.confortRobotValue = newValue);
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
                                        value: _model.confortEtiquetteValue ??= false,
                                        onChanged: (newValue) async {
                                          setState(() => _model.confortEtiquetteValue = newValue);
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
                                        value: _model.confortMonayeurValue,
                                        onChanged: (newValue) async {
                                          setState(() => _model.confortMonayeurValue = newValue);
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
                                        value: _model.confortCimValue ??= false,
                                        onChanged: (newValue) async {
                                          setState(() => _model.confortCimValue = newValue);
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
                                        value: _model.confortChauffageValue ??= false,
                                        onChanged: (newValue) async {
                                          setState(() => _model.confortChauffageValue = newValue);
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
                                        value: _model.confortVigileValue ??= false,
                                        onChanged: (newValue) async {
                                          setState(() => _model.confortVigileValue = newValue);
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
                                            'Comité d’entreprise',
                                            style: FlutterFlowTheme.of(context).bodyMedium,
                                          ),
                                        ],
                                      ),
                                      Switch.adaptive(
                                        value: _model.confortComiteEntrepriseValue ??= false,
                                        onChanged: (newValue) async {
                                          setState(() => _model.confortComiteEntrepriseValue = newValue);
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
                                          child: custom_widgets.SliderSimple(
                                              slider: 1,
                                              onChanged: (value) {
                                                providerPharmacieRegister.setTendences(0, 'Ordonances', value);
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
                                          child: custom_widgets.SliderSimple(
                                            slider: 1,
                                            onChanged: (value) {
                                              providerPharmacieRegister.setTendences(1, 'Cosmétiques', value);
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
                                          child: custom_widgets.SliderSimple(
                                              slider: 1,
                                              onChanged: (value) {
                                                providerPharmacieRegister.setTendences(2, 'Phyto / aroma', value);
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
                                          child: custom_widgets.SliderSimple(
                                              slider: 1,
                                              onChanged: (value) {
                                                providerPharmacieRegister.setTendences(3, 'Nutrition', value);
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
                                          child: custom_widgets.SliderSimple(
                                              slider: 1,
                                              onChanged: (value) {
                                                providerPharmacieRegister.setTendences(4, 'Conseil', value);
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
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
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
                                    controller: _model.phonePharmacieController2,
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
                                    validator: _model.phonePharmacieController2Validator.asValidator(context),
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
                            createPharmacie(context);
                            context.pushNamed('ValidateAccount');
                          },
                          text: 'Créer la pharmacie',
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
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
