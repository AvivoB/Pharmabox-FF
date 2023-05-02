import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
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
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool? comptencesTestCovidValue1;
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
  // State field(s) for ComptencesTestCovid widget.
  bool? comptencesTestCovidValue2;
  // State field(s) for ComptencesVaccination widget.
  bool? comptencesVaccinationValue1;
  // State field(s) for ComptencesTiersPayant widget.
  bool? comptencesTiersPayantValue1;
  // State field(s) for ComptencesLabo widget.
  bool? comptencesLaboValue4;
  // State field(s) for MissionPreparation widget.
  bool? missionPreparationValue1;
  // State field(s) for ComptencesTestCovid widget.
  bool? comptencesTestCovidValue3;
  // State field(s) for ComptencesVaccination widget.
  bool? comptencesVaccinationValue2;
  // State field(s) for ComptencesTiersPayant widget.
  bool? comptencesTiersPayantValue2;
  // State field(s) for ComptencesLabo widget.
  bool? comptencesLaboValue5;
  // State field(s) for MissionPreparation widget.
  bool? missionPreparationValue2;
  // State field(s) for MissionPreparation widget.
  bool? missionPreparationValue3;
  // State field(s) for MissionPreparation widget.
  bool? missionPreparationValue4;
  // State field(s) for MissionPreparation widget.
  bool? missionPreparationValue5;
  // State field(s) for ComptencesTestCovid widget.
  bool? comptencesTestCovidValue4;
  // State field(s) for ComptencesVaccination widget.
  bool? comptencesVaccinationValue3;
  // State field(s) for ComptencesTiersPayant widget.
  bool? comptencesTiersPayantValue3;
  // State field(s) for ComptencesLabo widget.
  bool? comptencesLaboValue6;
  // State field(s) for MissionPreparation widget.
  bool? missionPreparationValue6;
  // State field(s) for PhonePharmacie widget.
  TextEditingController? phonePharmacieController2;
  String? Function(BuildContext, String?)? phonePharmacieController2Validator;
  // State field(s) for PhonePharmacie widget.
  TextEditingController? phonePharmacieController3;
  String? Function(BuildContext, String?)? phonePharmacieController3Validator;
  // State field(s) for PhonePharmacie widget.
  TextEditingController? phonePharmacieController4;
  String? Function(BuildContext, String?)? phonePharmacieController4Validator;
  // State field(s) for PhonePharmacie widget.
  TextEditingController? phonePharmacieController5;
  String? Function(BuildContext, String?)? phonePharmacieController5Validator;
  // State field(s) for PhonePharmacie widget.
  TextEditingController? phonePharmacieController6;
  String? Function(BuildContext, String?)? phonePharmacieController6Validator;
  // State field(s) for PhonePharmacie widget.
  TextEditingController? phonePharmacieController7;
  String? Function(BuildContext, String?)? phonePharmacieController7Validator;
  // State field(s) for PhonePharmacie widget.
  TextEditingController? phonePharmacieController8;
  String? Function(BuildContext, String?)? phonePharmacieController8Validator;

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
    phonePharmacieController3?.dispose();
    phonePharmacieController4?.dispose();
    phonePharmacieController5?.dispose();
    phonePharmacieController6?.dispose();
    phonePharmacieController7?.dispose();
    phonePharmacieController8?.dispose();
  }

  /// Additional helper methods are added here.

}
