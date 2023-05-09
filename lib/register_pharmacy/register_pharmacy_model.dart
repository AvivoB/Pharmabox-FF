import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  ///  Local state fields for this page.

  List<int> titulaires = [];
  void addToTitulaires(int item) => titulaires.add(item);
  void removeFromTitulaires(int item) => titulaires.remove(item);
  void removeAtIndexFromTitulaires(int index) => titulaires.removeAt(index);

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl = '';

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
  bool? comptencesTestCovidValue;
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
  final pharmacieAdresseMask = MaskTextInputFormatter(mask: '## ## ## ## ##');
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
  bool? nonSTOPValue;                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
  DateTime? datePicked1;
  DateTime? datePicked2;
  // State field(s) for lundiMat widget.
  bool? lundiMatValue1;
  DateTime? datePicked3;
  DateTime? datePicked4;
  // State field(s) for lundiMat widget.
  bool? lundiMatValue2;
  DateTime? datePicked5;
  DateTime? datePicked6;
  // State field(s) for lundiMat widget.
  bool? lundiMatValue3;
  DateTime? datePicked7;
  DateTime? datePicked8;
  // State field(s) for lundiMat widget.
  bool? lundiMatValue4;
  DateTime? datePicked9;
  DateTime? datePicked10;
  // State field(s) for lundiMat widget.
  bool? lundiMatValue5;
  DateTime? datePicked11;
  DateTime? datePicked12;
  // State field(s) for lundiMat widget.
  bool? lundiMatValue6;
  DateTime? datePicked13;
  DateTime? datePicked14;
  // State field(s) for lundiMat widget.
  bool? lundiMatValue7;
  DateTime? datePicked15;
  DateTime? datePicked16;
  // State field(s) for lundiMat widget.
  bool? lundiMatValue8;
  DateTime? datePicked17;
  DateTime? datePicked18;
  // State field(s) for lundiMat widget.
  bool? lundiMatValue9;
  DateTime? datePicked19;
  DateTime? datePicked20;
  // State field(s) for lundiMat widget.
  bool? lundiMatValue10;
  DateTime? datePicked21;
  DateTime? datePicked22;
  // State field(s) for lundiMat widget.
  bool? lundiMatValue11;
  DateTime? datePicked23;
  DateTime? datePicked24;
  // State field(s) for lundiMat widget.
  bool? lundiMatValue12;
  DateTime? datePicked25;
  DateTime? datePicked26;
  // State field(s) for lundiMat widget.
  bool? lundiMatValue13;
  DateTime? datePicked27;
  DateTime? datePicked28;
  // State field(s) for lundiMat widget.
  bool? lundiMatValue14;
  // State field(s) for TypologieCentrecommercial widget.
  bool? typologieCentrecommercialValue;
  // State field(s) for TypologieCentreville widget.
  bool? typologieCentrevilleValue;
  // State field(s) for TypologieAeroport widget.
  bool? typologieAeroportValue;
  // State field(s) for ComptencesLabo widget.
  bool? comptencesLaboValue1;
  // State field(s) for ComptencesLabo widget.
  bool? comptencesLaboValue2;
  // State field(s) for ComptencesLabo widget.
  bool? comptencesLaboValue3;
  // State field(s) for ComptencesTROD widget.
  bool? comptencesTRODValue;
  // State field(s) for PatientParJour widget.
  String? patientParJourValue;
  FormFieldController<String>? patientParJourValueController;
  // State field(s) for MissioTestCovid widget.
  bool? missioTestCovidValue;
  // State field(s) for MissionVaccination widget.
  bool? missionVaccinationValue;
  // State field(s) for MissionEnretienPharma widget.
  bool? missionEnretienPharmaValue;
  // State field(s) for MissionsBorne widget.
  bool? missionsBorneValue;
  // State field(s) for MissionPreparation widget.
  bool? missionPreparationValue;
  // State field(s) for ConfortSallePause widget.
  bool? confortSallePauseValue;
  // State field(s) for ConfortRobot widget.
  bool? confortRobotValue;
  // State field(s) for ConfortEtiquette widget.
  bool? confortEtiquetteValue;
  // State field(s) for ConfortMonayeur widget.
  bool? confortMonayeurValue;
  // State field(s) for ConfortCim widget.
  bool? confortCimValue;
  // State field(s) for ConfortChauffage widget.
  bool? confortChauffageValue;
  // State field(s) for ConfortVigile widget.
  bool? confortVigileValue;
  // State field(s) for ConfortComiteEntreprise widget.
  bool? confortComiteEntrepriseValue;
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

  // Enregistrement dans la base
  createPharmacie() {
    final firestore = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;

    final CollectionReference<Map<String, dynamic>> pharmaciesRef =
        FirebaseFirestore.instance.collection('pharmacies');

  String typologie = '';
  // Typologie :
  if(typologieCentrecommercialValue!) {
    typologie = 'Centre commercial';
  }
  if(typologieCentrevilleValue!) {
    typologie = 'Centre ville';
  }
  if(typologieAeroportValue!) {
    typologie = 'Aéroport';
  }
  if(comptencesLaboValue1!) {
    typologie = 'Gare';
  }
  if(comptencesLaboValue2!) {
    typologie = 'Quartier';
  }
  if(comptencesLaboValue3!) {
    typologie = 'Lieu touristique';
  }
  if(comptencesTRODValue!) {
    typologie = 'Zone rurale';
  }


  List missions = [];
  if(missioTestCovidValue!) {
    missions.add('Test COVID');
  }
  if(missionVaccinationValue!) {
    missions.add('Vaccination');
  }
  if(missionEnretienPharmaValue!) {
    missions.add('Entretien pharmaceutique');
  }
  if(missionsBorneValue!) {
    missions.add('Borne de télé-médecine');
  }
  if(missionPreparationValue!) {
    missions.add('externalisé');
  } else {
    missions.add('par l\'équipe');
  }


    pharmaciesRef.doc().set({
      'user_id' : currentUser!.uid,
      'name': nomdelapharmacieController1.text,
      'presentation': presentationController.text,
      'titulaire_principal': nomdelapharmacieController2.text,
      'titulaires_autres': titulaires,
      'maitre_stage': '',
      'contact_pharma': {
        'email': emailPharmacieController.text,
        'telephone': phonePharmacieController1.text,
        'preference_contact': preferenceContactValue,
      },
      'situation_geographique': {
        'adresse': pharmacieAdresseController.text,
        'lat_long': LatLng(255, 255)
      },
      'accessibilite': {
        'rer': rerController.text,
        'metro': metroController.text,
        'bus': busController.text,
        'tram': tramwayController1.text,
        'gare': tramwayController2.text,
        'stationnement': parkingValue
      },
      'horaires': {
        'Lundi': {
          'matin': datePicked3,
          'aprem': datePicked4
        },
        'Mardi': {
          'matin': datePicked5,
          'aprem': datePicked6
        },
        'Mercredi': {
          'matin': datePicked7,
          'aprem': datePicked8
        },
        'Jeudi': {
          'matin': datePicked9,
          'aprem': datePicked10
        },
        'vendredi': {
          'matin': datePicked11,
          'aprem': datePicked12
        },
        'Samedi': {
          'matin': datePicked13,
          'aprem': datePicked14
        },
        'Dimanche': {
          'matin': datePicked15,
          'aprem': datePicked16
        },
        // '24H/24': (nonSTOPValue) ? true : false,
      },
      'typologie': typologie,
      'nb_patient_jour': patientParJourValue,
      // 'lgo': lgo,
      'missions': missions,
      // 'confort': confort,
      // 'tendances': tendances,
      'equipe': {
        'nb_pharmaciens': (phonePharmacieController2.text != '') ? phonePharmacieController2.text : 0,
        'nb_preparateurs': (nbPreparateurController.text != '') ? phonePharmacieController2.text : 0,
        'nb_rayonnistes': (nbRayonnistesController.text != '') ? nbRayonnistesController.text : 0,
        'nb_conseillers': (nbConseillersController.text != '') ? nbConseillersController.text : 0,
        'nb_apprentis': (nbApprentiController.text != '') ? nbApprentiController.text : 0,
        'nb_etudiants': (nbEtudiantsController.text != '') ? nbEtudiantsController.text : 0,
        'nb_etudiants_6eme_annee': (nbEtudiants6emeController.text != '') ? nbEtudiants6emeController.text : 0,
      }
    });
  }
}
