import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PopupLgoModel extends FlutterFlowModel {
  ///  Local state fields for this component.

  List<String> lgoTabRegister = [];
  void addToLgoTabRegister(String item) => lgoTabRegister.add(item);
  void removeFromLgoTabRegister(String item) => lgoTabRegister.remove(item);
  void removeAtIndexFromLgoTabRegister(int index) =>
      lgoTabRegister.removeAt(index);

  ///  State fields for stateful widgets in this component.

  // State field(s) for LgoFilter widget.
  TextEditingController? lgoFilterController;
  String? Function(BuildContext, String?)? lgoFilterControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    lgoFilterController?.dispose();
  }

  /// Additional helper methods are added here.

}
