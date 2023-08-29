import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CardSearchProfilModel extends FlutterFlowModel {
  ///  Local state fields for this component.

  List contratType = [];

  List horaireDispoInterim = [];

  bool? isActive;

  void addToContratType(String item) {
    if (!contratType.contains(item)) {
      contratType.add(item);
    }
  }

  void removeFromContratType(String item) => contratType.remove(item);
  void removeAtIndexFromContratType(int index) => contratType.removeAt(index);

  ///  State fields for stateful widgets in this component.

  // State field(s) for Localisation widget.
  TextEditingController? localisationController;
  String? Function(BuildContext, String?)? localisationControllerValidator;
  // State field(s) for Contrat widget.
  String? contratValue;
  FormFieldController<String>? contratValueController;
  // State field(s) for DureMois widget.
  TextEditingController? dureMoisController;
  String? Function(BuildContext, String?)? dureMoisControllerValidator;
  // State field(s) for Tempspleinpartiel widget.
  String? tempspleinpartielValue;
  FormFieldController<String>? tempspleinpartielValueController;
  // State field(s) for DebutImmediate widget.
  bool? debutImmediateValue;
  // State field(s) for DebutContrat widget.
  TextEditingController? debutContratController;
  String? Function(BuildContext, String?)? debutContratControllerValidator;
  DateTime? datePicked;
  // State field(s) for SalaireMensuelNet widget.
  TextEditingController? salaireMensuelNetController;
  String? Function(BuildContext, String?)? salaireMensuelNetControllerValidator;
  // State field(s) for PairImpaire widget.
  bool? pairImpaireValue;

  List grilleHoraire = [];
  List grilleHoraireImpaire = [];

  TextEditingController? rayonController;
  String? Function(BuildContext, String?)? rayonControllerValidator;
  // State field(s) for NomOffre widget.
  TextEditingController? nomOffreController;
  String? Function(BuildContext, String?)? nomOffreControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    localisationController?.dispose();
    dureMoisController?.dispose();
    debutContratController?.dispose();
    salaireMensuelNetController?.dispose();
    rayonController?.dispose();
    nomOffreController?.dispose();
  }

  /// Additional helper methods are added here.
}
