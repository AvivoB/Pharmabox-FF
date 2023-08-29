import '/composants/card_pharmacie/card_pharmacie_widget.dart';
import '/composants/card_user/card_user_widget.dart';
import '/composants/header_app/header_app_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReseauModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  // Model for HeaderApp component.
  late HeaderAppModel headerAppModel;
  // Model for CardUser component.
  late CardUserModel cardUserModel1;
  // Model for CardUser component.
  late CardUserModel cardUserModel2;
  // Model for CardPharmacie component.
  late CardPharmacieModel cardPharmacieModel;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    headerAppModel = createModel(context, () => HeaderAppModel());
    cardUserModel1 = createModel(context, () => CardUserModel());
    cardUserModel2 = createModel(context, () => CardUserModel());
    cardPharmacieModel = createModel(context, () => CardPharmacieModel());
  }

  void dispose() {
    headerAppModel.dispose();
    cardUserModel1.dispose();
    cardUserModel2.dispose();
    cardPharmacieModel.dispose();
  }

  /// Additional helper methods are added here.
}
