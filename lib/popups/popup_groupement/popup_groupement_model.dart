import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class PopupGroupementModel extends FlutterFlowModel {
  ///  Local state fields for this component.

  String? searchField;

  ///  State fields for stateful widgets in this component.

  // State field(s) for GroupementFilter widget.
  TextEditingController? groupementFilterController;
  String? Function(BuildContext, String?)? groupementFilterControllerValidator;
  // State field(s) for ListView widget.
  PagingController<DocumentSnapshot?, GroupementsRecord>? pagingController;
  Query? pagingQuery;
  List<StreamSubscription?> streamSubscriptions = [];

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    groupementFilterController?.dispose();
    streamSubscriptions.forEach((s) => s?.cancel());
  }

  /// Additional helper methods are added here.

}
