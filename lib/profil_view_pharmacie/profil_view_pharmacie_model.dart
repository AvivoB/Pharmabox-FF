import '/composants/header_app/header_app_widget.dart';
import '/composants/list_skill_with_slider/list_skill_with_slider_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/popups/popup_profil/popup_profil_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PharmacieProfilViewModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  // Model for HeaderApp component.
  late HeaderAppModel headerAppModel;
  // Model for ListSkillWithSlider component.
  late ListSkillWithSliderModel listSkillWithSliderModel;

  List<String> imagePharmacie = [];

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    headerAppModel = createModel(context, () => HeaderAppModel());
    listSkillWithSliderModel = createModel(context, () => ListSkillWithSliderModel());
  }

  void dispose() {
    headerAppModel.dispose();
    listSkillWithSliderModel.dispose();
  }

  /// Additional helper methods are added here.
}
