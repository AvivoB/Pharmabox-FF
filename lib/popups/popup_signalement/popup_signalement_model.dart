import 'package:pharmabox/flutter_flow/form_field_controller.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class PopupSignalementModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Poste widget.
  String? contentType;
  FormFieldController<String>? contentTypeController;

  TextEditingController? comment;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    contentTypeController?.dispose();
  }

  /// Additional helper methods are added here.
}
