import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class ProfilModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Model for HeaderApp component.
  late HeaderAppModel headerAppModel;
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

  bool comptencesTestCovidValue = false;
  // State field(s) for ComptencesVaccination widget.
  bool comptencesVaccinationValue = false;
  // State field(s) for ComptencesTiersPayant widget.
  bool comptencesTiersPayantValue = false;
  // State field(s) for ComptencesLabo widget.
  bool comptencesLaboValue = false;
  // State field(s) for ComptencesTROD widget.
  bool comptencesTRODValue = false;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    headerAppModel = createModel(context, () => HeaderAppModel());
  }

  void dispose() {
    headerAppModel.dispose();
    nomFamilleController?.dispose();
    prenomController?.dispose();
    emailController?.dispose();
    telephoneController?.dispose();
    birthDateController?.dispose();
    postcodeController?.dispose();
    cityController?.dispose();
    presentationController?.dispose();
  }

  /// Additional helper methods are added here.
}
