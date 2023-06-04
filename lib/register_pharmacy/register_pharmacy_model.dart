import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pharmabox/register_pharmacy/register_pharmacie_provider.dart';

import '/backend/firebase_storage/storage.dart';
import '/composants/maps_widget_adresse_pharmacie/maps_widget_adresse_pharmacie_widget.dart';
import '/composants/repeater_field/repeater_field_widget.dart';
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

class RegisterPharmacyModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading = false;

  List<String> imagePharmacie = [];

  // State field(s) for Nomdelapharmacie widget.
  TextEditingController? nomdelapharmacieController1;
  String? Function(BuildContext, String?)? nomdelapharmacieController1Validator;
  // State field(s) for Nomdelapharmacie widget.
  TextEditingController? nomdelapharmacieController2;
  String? Function(BuildContext, String?)? nomdelapharmacieController2Validator;
  // Model for repeaterField component.
  late RepeaterFieldModel repeaterFieldModel;
  // State field(s) for Presentation widget.
  TextEditingController? presentationController;
  String? Function(BuildContext, String?)? presentationControllerValidator;
  // State field(s) for ComptencesTestCovid widget.
  bool comptencesTestCovidValue = false;
  // State field(s) for EmailPharmacie widget.
  TextEditingController? emailPharmacieController;
  String? Function(BuildContext, String?)? emailPharmacieControllerValidator;
  // State field(s) for PhonePharmacie widget.
  TextEditingController? phonePharmacieController1;
  final phonePharmacieMask1 = MaskTextInputFormatter(mask: '## ## ## ## ##');
  String? Function(BuildContext, String?)? phonePharmacieController1Validator;
  // State field(s) for PreferenceContact widget.
  String? preferenceContactValue;
  FormFieldController<String>? preferenceContactValueController;
  // State field(s) for PharmacieAdresse widget.
  TextEditingController? pharmacieAdresseController;
  TextEditingController? pharmacieAdressePostCode;
  TextEditingController? pharmacieAdresseVille;
  TextEditingController? pharmacieAdresseArrondissement;
  TextEditingController? pharmacieAdresseRegion;

// State field for pharmacieLaLng get location
  TextEditingController? pharmacieLat;
// State field for pharmacieLaLng get location
  TextEditingController? pharmacieLong;

  String? Function(BuildContext, String?)? pharmacieAdresseControllerValidator;
  // Model for MapsWidgetAdressePharmacie component.
  late MapsWidgetAdressePharmacieModel mapsWidgetAdressePharmacieModel;
  // State field(s) for RER widget.
  TextEditingController? rerController;
  String? Function(BuildContext, String?)? rerControllerValidator;
  // State field(s) for Metro widget.
  TextEditingController? metroController;
  String? Function(BuildContext, String?)? metroControllerValidator;
  // State field(s) for Bus widget.
  TextEditingController? busController;
  String? Function(BuildContext, String?)? busControllerValidator;
  // State field(s) for Tramway widget.
  TextEditingController? tramwayController1;
  String? Function(BuildContext, String?)? tramwayController1Validator;
  // State field(s) for Tramway widget.
  TextEditingController? tramwayController2;
  String? Function(BuildContext, String?)? tramwayController2Validator;
  // State field(s) for Parking widget.
  String? parkingValue;
  FormFieldController<String>? parkingValueController;
  // State field(s) for nonSTOP widget.
  bool nonSTOPValue = false;


  // Lundi
  bool lundiMatValue1 = false;
  DateTime? datePicked1;
  DateTime? datePicked2;
 
  bool lundiMatValue2 = false;
  DateTime? datePicked3;
  DateTime? datePicked4;

// Mardi
  bool lundiMatValue3 = false;
  DateTime? datePicked5;
  DateTime? datePicked6;

  bool lundiMatValue4 = false;
  DateTime? datePicked7;
  DateTime? datePicked8;

  // Mercredi
  bool lundiMatValue5 = false;
  DateTime? datePicked9;
  DateTime? datePicked10;

  bool lundiMatValue6 = false;
  DateTime? datePicked11;
  DateTime? datePicked12;

  // Jeudi
  bool lundiMatValue7 = false;
  DateTime? datePicked13;
  DateTime? datePicked14;

  bool lundiMatValue8 = false;
  DateTime? datePicked15;
  DateTime? datePicked16;
 
  // Vendredi
  bool lundiMatValue9 = false;
  DateTime? datePicked17;
  DateTime? datePicked18;

  bool lundiMatValue10 = false;
  DateTime? datePicked19;
  DateTime? datePicked20;
  
  // Samedi
  bool lundiMatValue11 = false;
  DateTime? datePicked21;
  DateTime? datePicked22;

  bool lundiMatValue12 = false;
  DateTime? datePicked23;
  DateTime? datePicked24;

  // Dimanche
  bool lundiMatValue13 = false;
  DateTime? datePicked25;
  DateTime? datePicked26;
  bool lundiMatValue14 = false;
  DateTime? datePicked27;
  DateTime? datePicked28;


  // State field(s) for TypologieCentrecommercial widget.
  bool typologieCentrecommercialValue = false;
  // State field(s) for TypologieCentreville widget.
  bool typologieCentrevilleValue = false;
  // State field(s) for TypologieAeroport widget.
  bool typologieAeroportValue = false;
  // State field(s) for ComptencesLabo widget.
  bool comptencesLaboValue1 = false;
  // State field(s) for ComptencesLabo widget.
  bool comptencesLaboValue2 = false;
  // State field(s) for ComptencesLabo widget.
  bool comptencesLaboValue3 = false;
  // State field(s) for ComptencesTROD widget.
  bool comptencesTRODValue = false;
  // State field(s) for PatientParJour widget.
  String? patientParJourValue;
  FormFieldController<String>? patientParJourValueController;
  // State field(s) for MissioTestCovid widget.
  bool missioTestCovidValue = false;
  // State field(s) for MissionVaccination widget.
  bool missionVaccinationValue = false;
  // State field(s) for MissionEnretienPharma widget.
  bool missionEnretienPharmaValue = false;
  // State field(s) for MissionsBorne widget.
  bool missionsBorneValue = false;
  // State field(s) for MissionPreparation widget.
  bool missionPreparationValue = false;
  // State field(s) for ConfortSallePause widget.
  bool confortSallePauseValue = false;
  // State field(s) for ConfortRobot widget.
  bool confortRobotValue = false;
  // State field(s) for ConfortEtiquette widget.
  bool confortEtiquetteValue = false;
  // State field(s) for ConfortMonayeur widget.
  bool confortMonayeurValue = false;
  // State field(s) for ConfortCim widget.
  bool confortCimValue = false;
  // State field(s) for ConfortChauffage widget.
  bool confortChauffageValue = false;
  // State field(s) for ConfortVigile widget.
  bool confortVigileValue = false;
  // State field(s) for ConfortComiteEntreprise widget.
  bool confortComiteEntrepriseValue = false;
  // State field(s) for Slider widget.
  double? sliderValue1;
  // State field(s) for Slider widget.
  double? sliderValue2;
  // State field(s) for Slider widget.
  double? sliderValue3;
  // State field(s) for Slider widget.
  double? sliderValue4;
  // State field(s) for Slider widget.
  double? sliderValue5;
  // State field(s) for PhonePharmacie widget.
  TextEditingController? phonePharmacieController2;
  String? Function(BuildContext, String?)? phonePharmacieController2Validator;
  // State field(s) for NbPreparateur widget.
  TextEditingController? nbPreparateurController;
  String? Function(BuildContext, String?)? nbPreparateurControllerValidator;
  // State field(s) for NbRayonnistes widget.
  TextEditingController? nbRayonnistesController;
  String? Function(BuildContext, String?)? nbRayonnistesControllerValidator;
  // State field(s) for NbConseillers widget.
  TextEditingController? nbConseillersController;
  String? Function(BuildContext, String?)? nbConseillersControllerValidator;
  // State field(s) for NbApprenti widget.
  TextEditingController? nbApprentiController;
  String? Function(BuildContext, String?)? nbApprentiControllerValidator;
  // State field(s) for NbEtudiants widget.
  TextEditingController? nbEtudiantsController;
  String? Function(BuildContext, String?)? nbEtudiantsControllerValidator;
  // State field(s) for NbEtudiants6eme widget.
  TextEditingController? nbEtudiants6emeController;
  String? Function(BuildContext, String?)? nbEtudiants6emeControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    repeaterFieldModel = createModel(context, () => RepeaterFieldModel());
    mapsWidgetAdressePharmacieModel =
        createModel(context, () => MapsWidgetAdressePharmacieModel());
  }

  void dispose() {
    nomdelapharmacieController1?.dispose();
    nomdelapharmacieController2?.dispose();
    repeaterFieldModel.dispose();
    presentationController?.dispose();
    emailPharmacieController?.dispose();
    phonePharmacieController1?.dispose();
    pharmacieAdresseController?.dispose();
    mapsWidgetAdressePharmacieModel.dispose();
    rerController?.dispose();
    metroController?.dispose();
    busController?.dispose();
    tramwayController1?.dispose();
    tramwayController2?.dispose();
    phonePharmacieController2?.dispose();
    nbPreparateurController?.dispose();
    nbRayonnistesController?.dispose();
    nbConseillersController?.dispose();
    nbApprentiController?.dispose();
    nbEtudiantsController?.dispose();
    nbEtudiants6emeController?.dispose();
  }

  /// Additional helper methods are added here.
}
