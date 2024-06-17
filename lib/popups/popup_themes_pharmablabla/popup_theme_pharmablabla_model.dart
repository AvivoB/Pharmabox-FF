import 'package:pharmabox/register_step/register_step_model.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PopupThemePharmablablaModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this component.

  // State field(s) for LgoFilter widget.
  TextEditingController? themePharmablabla;
  String? Function(BuildContext, String?)? themePharmablablaValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    themePharmablabla?.dispose();
  }

  /// Additional helper methods are added here.

  getThemes() {
    List<String> listThemePharmablabla = [
      'Emploi et installation',
      'Vente et achat',
      'Recommandation et contact',
      'Anectode et coup de gueule',
      'Desctockage et commandes groupée',
      'Info et aide',
    ];

    return listThemePharmablabla;
  }
}
