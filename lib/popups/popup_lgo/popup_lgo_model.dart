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
      {"image": "ActiPharm.jpg", "name": "ActiPharm", "niveau": 0},
      {"image": "CADUCIEL.jpg", "name": "CADUCIEL", "niveau": 0},
      {"image": "Crystal.jpg", "name": "Crystal", "niveau": 0},
      {"image": "Leo.jpg", "name": "Léo", "niveau": 0},
      {"image": "LGPI.jpg", "name": "LGPI", "niveau": 0},
      {"image": "Pharmagest.jpg", "name": "Pharmagest", "niveau": 0},
      {"image": "Pharmaland.jpg", "name": "Pharmaland", "niveau": 0},
      {"image": "PharmaVitale.jpg", "name": "PharmaVitale", "niveau": 0},
      {"image": "Pharmony.jpg", "name": "Pharmony", "niveau": 0},
      {"image": "SMART_RX.jpg", "name": "SMART RX", "niveau": 0},
      {"image": "Vindilis.jpg", "name": "Vindilis", "niveau": 0},
      {"image": "Visiopharm.jpg", "name": "Visiopharm", "niveau": 0},
      {"image": "Winpharma.jpg", "name": "Winpharma", "niveau": 0},
    ];

    return listLGO.toList();
  }
}
