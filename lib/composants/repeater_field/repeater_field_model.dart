import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RepeaterFieldModel extends FlutterFlowModel {
  ///  Local state fields for this component.

  List<int> itemsFields = [];
  void addToItemsFields(int item) => itemsFields.add(item);
  void removeFromItemsFields(int item) => itemsFields.remove(item);
  void removeAtIndexFromItemsFields(int index) => itemsFields.removeAt(index);

  ///  State fields for stateful widgets in this component.

  // State field(s) for City widget.
  TextEditingController? cityController;
  String? Function(BuildContext, String?)? cityControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    cityController?.dispose();
  }

  /// Additional helper methods are added here.

}
