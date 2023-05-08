import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PopupLgoModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this component.

  // State field(s) for LgoFilter widget.
  TextEditingController? lgoFilterController;
  String? Function(BuildContext, String?)? lgoFilterControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    lgoFilterController?.dispose();
  }


  // Liste les lgo selectionnés pour les renvoyer vers RegisterStepWidget
  static List<Map> selectedLGO = [];

  // Recupere les LGO dans le stockage local
  static selectLGO() {

    List<Map> listLGO = [
      {"image": "ActiPharm.jpg", "name": "ActiPharm"},
      {"image": "CADUCIEL.jpg", "name": "CADUCIEL"},
      {"image": "Crystal.jpg", "name": "Crystal"},
      {"image": "Leo.jpg", "name": "Léo"},
      {"image": "LGPI.jpg", "name": "LGPI"},
      {"image": "Pharmagest.jpg", "name": "Pharmagest"},
      {"image": "Pharmaland.jpg", "name": "Pharmaland"},
      {"image": "PharmaVitale.jpg", "name": "PharmaVitale"},
      {"image": "Pharmony.jpg", "name": "Pharmony"},
      {"image": "SMART_RX.jpg", "name": "SMART RX"},
      {"image": "Vindilis.jpg", "name": "Vindilis"},
      {"image": "Visiopharm.jpg", "name": "Visiopharm"},
      {"image": "Winpharma.jpg", "name": "Winpharma"}
    ];

    return listLGO.toList();
  }
}
