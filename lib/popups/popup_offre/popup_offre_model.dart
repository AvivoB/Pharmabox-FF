import '/flutter_flow/flutter_flow_choice_chips.dart';
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

class PopupOffreModel extends FlutterFlowModel {
  ///  Local state fields for this component.

  List<String> contratType = [];
  void addToContratType(String item) => contratType.add(item);
  void removeFromContratType(String item) => contratType.remove(item);
  void removeAtIndexFromContratType(int index) => contratType.removeAt(index);

  ///  State fields for stateful widgets in this component.

  // State field(s) for Poste widget.
  String? posteValue;
  FormFieldController<String>? posteValueController;
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
  // State field(s) for SalaireNegocierSwitc widget.
  bool? salaireNegocierSwitcValue;
  // State field(s) for SalaireMensuelNet widget.
  TextEditingController? salaireMensuelNetController;
  String? Function(BuildContext, String?)? salaireMensuelNetControllerValidator;
  // State field(s) for PosteAresponsa widget.
  String? posteAresponsaValue;
  FormFieldController<List<String>>? posteAresponsaValueController;
  // State field(s) for Avantages widget.
  List<String>? avantagesValues;
  FormFieldController<List<String>>? avantagesValueController;
  // State field(s) for PairImpaire widget.
  bool? pairImpaireValue;
  // State field(s) for DescriptionOffre widget.
  TextEditingController? descriptionOffreController;
  String? Function(BuildContext, String?)? descriptionOffreControllerValidator;
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
    descriptionOffreController?.dispose();
    nomOffreController?.dispose();
  }

  /// Additional helper methods are added here.

}
