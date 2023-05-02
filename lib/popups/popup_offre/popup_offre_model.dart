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
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class PopupOffreModel extends FlutterFlowModel {
  ///  Local state fields for this component.

  List<String> contratType = [];
  void addToContratType(String item) => contratType.add(item);
  void removeFromContratType(String item) => contratType.remove(item);
  void removeAtIndexFromContratType(int index) => contratType.removeAt(index);

  ///  State fields for stateful widgets in this component.

  // State field(s) for Poste widget.
  String? posteValue1;
  FormFieldController<String>? posteValueController1;
  // State field(s) for LgoFilter widget.
  TextEditingController? lgoFilterController1;
  String? Function(BuildContext, String?)? lgoFilterController1Validator;
  // State field(s) for Poste widget.
  String? posteValue2;
  FormFieldController<String>? posteValueController2;
  // State field(s) for TextField widget.
  TextEditingController? textController2;
  final textFieldMask = MaskTextInputFormatter(mask: '## mois');
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for Tempspleinpartiel widget.
  String? tempspleinpartielValue;
  FormFieldController<String>? tempspleinpartielValueController;
  // State field(s) for DebutImmediate widget.
  bool? debutImmediateValue;
  // State field(s) for LgoFilter widget.
  TextEditingController? lgoFilterController2;
  String? Function(BuildContext, String?)? lgoFilterController2Validator;
  DateTime? datePicked;
  // State field(s) for SalaireNegocierSwitc widget.
  bool? salaireNegocierSwitcValue1;
  // State field(s) for Salairenetmensuel widget.
  TextEditingController? salairenetmensuelController;
  final salairenetmensuelMask =
      MaskTextInputFormatter(mask: '# ### €  net/mois');
  String? Function(BuildContext, String?)? salairenetmensuelControllerValidator;
  // State field(s) for ChoiceChips widget.
  String? choiceChipsValue1;
  FormFieldController<List<String>>? choiceChipsValueController1;
  // State field(s) for ChoiceChips widget.
  List<String>? choiceChipsValues2;
  FormFieldController<List<String>>? choiceChipsValueController2;
  // State field(s) for SalaireNegocierSwitc widget.
  bool? salaireNegocierSwitcValue2;
  // State field(s) for DescriptionOffre widget.
  TextEditingController? descriptionOffreController;
  String? Function(BuildContext, String?)? descriptionOffreControllerValidator;
  // State field(s) for NomOffre widget.
  TextEditingController? nomOffreController;
  String? Function(BuildContext, String?)? nomOffreControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    lgoFilterController1?.dispose();
    textController2?.dispose();
    lgoFilterController2?.dispose();
    salairenetmensuelController?.dispose();
    descriptionOffreController?.dispose();
    nomOffreController?.dispose();
  }

  /// Additional helper methods are added here.

}
