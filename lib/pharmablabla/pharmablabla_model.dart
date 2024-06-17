import 'package:pharmabox/flutter_flow/form_field_controller.dart';

import '/composants/header_app/header_app_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/popups/popup_offre/popup_offre_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PharmaBlablaModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  // Model for HeaderApp component.
  late HeaderAppModel headerAppModel;

  TextEditingController? postContent;
  String reseauType = 'Tout Pharmabox';

  String? posteValue;
  FormFieldController<String>? posteValueController;

  var searchPost;


  String selectedTheme = 'Thème de discussion';


  List<Map> selectedLGO = [
    {"image": "Autre.jpg", "name": "Par LGO"}
  ];
  List<Map> selectedGroupement = [
    {"image": "Autre.jpg", "name": "Par groupement"}
  ];

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    headerAppModel = createModel(context, () => HeaderAppModel());
  }

  void dispose() {
    headerAppModel.dispose();
  }

  /// Additional helper methods are added here.
}
