import '/auth/firebase_auth/auth_util.dart';
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
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class PopupRechercheModel extends FlutterFlowModel {
  ///  Local state fields for this component.

  List<String> contratType = [];
  void addToContratType(String item) => contratType.add(item);
  void removeFromContratType(String item) => contratType.remove(item);
  void removeAtIndexFromContratType(int index) => contratType.removeAt(index);

  ///  State fields for stateful widgets in this component.

  // State field(s) for Localisation widget.
  TextEditingController? localisationController1;
  String? Function(BuildContext, String?)? localisationController1Validator;
  // State field(s) for Localisation widget.
  TextEditingController? localisationController2;
  String? Function(BuildContext, String?)? localisationController2Validator;
  // State field(s) for Poste widget.
  String? posteValue;
  FormFieldController<String>? posteValueController;
  // State field(s) for TextField widget.
  TextEditingController? textController3;
  final textFieldMask = MaskTextInputFormatter(mask: '## mois');
  String? Function(BuildContext, String?)? textController3Validator;
  // State field(s) for Tempspleinpartiel widget.
  String? tempspleinpartielValue;
  FormFieldController<String>? tempspleinpartielValueController;
  // State field(s) for DebutImmediate widget.
  bool? debutImmediateValue;
  // State field(s) for LgoFilter widget.
  TextEditingController? lgoFilterController;
  String? Function(BuildContext, String?)? lgoFilterControllerValidator;
  DateTime? datePicked;
  // State field(s) for SalaireNegocierSwitc widget.
  bool? salaireNegocierSwitcValue1;
  // State field(s) for Salairenetmensuel widget.
  TextEditingController? salairenetmensuelController;
  final salairenetmensuelMask =
      MaskTextInputFormatter(mask: '# ### €  net/mois');
  String? Function(BuildContext, String?)? salairenetmensuelControllerValidator;
  // State field(s) for SalaireNegocierSwitc widget.
  bool? salaireNegocierSwitcValue2;
  // State field(s) for NomRecherche widget.
  TextEditingController? nomRechercheController;
  String? Function(BuildContext, String?)? nomRechercheControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    localisationController1?.dispose();
    localisationController2?.dispose();
    textController3?.dispose();
    lgoFilterController?.dispose();
    salairenetmensuelController?.dispose();
    nomRechercheController?.dispose();
  }

  /// Additional helper methods are added here.

}
