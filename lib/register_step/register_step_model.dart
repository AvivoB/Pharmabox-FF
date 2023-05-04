import '/composants/list_skill_with_slider/list_skill_with_slider_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/popups/popup_experiences/popup_experiences_widget.dart';
import '/popups/popup_langues/popup_langues_widget.dart';
import '/popups/popup_lgo/popup_lgo_widget.dart';
import '/popups/popup_specialisation/popup_specialisation_widget.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmabox/constant.dart';

class RegisterStepModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for NomFamille widget.
  TextEditingController? nomFamilleController;
  String? Function(BuildContext, String?)? nomFamilleControllerValidator;
  // State field(s) for Prenom widget.
  TextEditingController? prenomController;
  String? Function(BuildContext, String?)? prenomControllerValidator;
  // State field(s) for Poste widget.
  String? posteValue;
  FormFieldController<String>? posteValueController;
  // State field(s) for Email widget.
  TextEditingController? emailController;
  String? Function(BuildContext, String?)? emailControllerValidator;
  // State field(s) for Telephone widget.
  TextEditingController? telephoneController;
  final telephoneMask = MaskTextInputFormatter(mask: '## ## ## ## ##');
  String? Function(BuildContext, String?)? telephoneControllerValidator;
  // State field(s) for BirthDate widget.
  TextEditingController? birthDateController;
  final birthDateMask = MaskTextInputFormatter(mask: '##/##/####');
  String? Function(BuildContext, String?)? birthDateControllerValidator;
  DateTime? datePicked;
  // State field(s) for Postcode widget.
  TextEditingController? postcodeController;
  final postcodeMask = MaskTextInputFormatter(mask: '#####');
  String? Function(BuildContext, String?)? postcodeControllerValidator;
  // State field(s) for City widget.
  TextEditingController? cityController;
  String? Function(BuildContext, String?)? cityControllerValidator;
  // State field(s) for Presentation widget.
  TextEditingController? presentationController;
  String? Function(BuildContext, String?)? presentationControllerValidator;
  // Model for ListSkillWithSlider component.
  late ListSkillWithSliderModel listSkillWithSliderModel1;
  // State field(s) for ComptencesTestCovid widget.
  bool? comptencesTestCovidValue;
  // State field(s) for ComptencesVaccination widget.
  bool? comptencesVaccinationValue;
  // State field(s) for ComptencesTiersPayant widget.
  bool? comptencesTiersPayantValue;
  // State field(s) for ComptencesLabo widget.
  bool? comptencesLaboValue;
  // State field(s) for ComptencesTROD widget.
  bool? comptencesTRODValue;
  // Model for ListSkillWithSlider component.
  late ListSkillWithSliderModel listSkillWithSliderModel2;
  // State field(s) for AllowNotifs widget.
  bool? allowNotifsValue;
  // State field(s) for AllowCGU widget.
  bool? allowCGUValue;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    listSkillWithSliderModel1 =
        createModel(context, () => ListSkillWithSliderModel());
    listSkillWithSliderModel2 =
        createModel(context, () => ListSkillWithSliderModel());
  }

  void dispose() {
    nomFamilleController?.dispose();
    prenomController?.dispose();
    emailController?.dispose();
    telephoneController?.dispose();
    birthDateController?.dispose();
    postcodeController?.dispose();
    cityController?.dispose();
    presentationController?.dispose();
    listSkillWithSliderModel1.dispose();
    listSkillWithSliderModel2.dispose();
  }

// Recupere les specialisations depuis le popup specialisation
  List<String> listeSpecialisation = [];

  deleteSpecialisation(specialisation) {
    listeSpecialisation.remove(specialisation);
  }

// Recupere les lgo depuis le popup
  List<Map> listeLGO = [];

  deleteLGO(lgo) {
    listeLGO.remove(lgo);
  }

  updateLevelLgo() {
  }

// Recupere les langues selectionnées
  List<Map> listeLangues = [];


}
