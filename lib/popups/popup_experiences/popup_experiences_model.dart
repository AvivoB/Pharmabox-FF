import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class PopupExperiencesModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this component.

  // State field(s) for LgoFilter widget.
  TextEditingController? lgoFilterController;
  String? Function(BuildContext, String?)? lgoFilterControllerValidator;
  // State field(s) for ExperienceDebut widget.
  TextEditingController? experienceDebutController;
  final experienceDebutMask = MaskTextInputFormatter(mask: '####');
  String? Function(BuildContext, String?)? experienceDebutControllerValidator;
  // State field(s) for ExperienceFin widget.
  TextEditingController? experienceFinController;
  final experienceFinMask = MaskTextInputFormatter(mask: '####');
  String? Function(BuildContext, String?)? experienceFinControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    lgoFilterController?.dispose();
    experienceDebutController?.dispose();
    experienceFinController?.dispose();
  }

  /// Additional helper methods are added here.

}
