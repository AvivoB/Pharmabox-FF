import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/composants/header_app/header_app_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart' hide LatLng;
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AnnuaireModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  // Model for HeaderApp component.
  late HeaderAppModel headerAppModel;
  // State field(s) for TextField widget.
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    headerAppModel = createModel(context, () => HeaderAppModel());
  }

  void dispose() {
    headerAppModel.dispose();
    textController?.dispose();
  }

}
