import '/composants/header_app/header_app_widget.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/popups/popup_offre/popup_offre_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PharmaJobModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  // Model for HeaderApp component.
  late HeaderAppModel headerAppModel;
  // State field(s) for SearchJob widget.
  TextEditingController? searchJobController;
  String? Function(BuildContext, String?)? searchJobControllerValidator;
  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    headerAppModel = createModel(context, () => HeaderAppModel());
  }

  void dispose() {
    headerAppModel.dispose();
    searchJobController?.dispose();
  }

  /// Additional helper methods are added here.
}
