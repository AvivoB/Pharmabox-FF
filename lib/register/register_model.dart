import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegisterModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for Email widget.
  TextEditingController? emailController;
  TextEditingController? nomController;
  TextEditingController? prenomController;
  String? Function(BuildContext, String?)? emailControllerValidator;

  var posteValueController;

  String? posteValue = '';

  String? _emailControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Adresse mail invalide';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'L\'adresse E-mail doit être valide';
    }
    return null;
  }

  // State field(s) for Motdepasse widget.
  TextEditingController? motdepasseController;
  late bool motdepasseVisibility;
  String? Function(BuildContext, String?)? motdepasseControllerValidator;
  String? _motdepasseControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Le mot de passe est obligatoire';
    }

    return null;
  }

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    emailControllerValidator = _emailControllerValidator;
    motdepasseVisibility = false;
    motdepasseControllerValidator = _motdepasseControllerValidator;
  }

  void dispose() {
    emailController?.dispose();
    motdepasseController?.dispose();
    nomController?.dispose();
    prenomController?.dispose(); 
  }

  /// Additional helper methods are added here.
}
