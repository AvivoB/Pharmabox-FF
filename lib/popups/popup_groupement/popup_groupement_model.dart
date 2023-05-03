import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PopupGroupementModel extends FlutterFlowModel {
  ///  Local state fields for this component.

  String? searchField;

  ///  State fields for stateful widgets in this component.

  // State field(s) for GroupementFilter widget.
  TextEditingController? groupementFilterController;
  String? Function(BuildContext, String?)? groupementFilterControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    groupementFilterController?.dispose();
  }

  /// Additional helper methods are added here.

}
