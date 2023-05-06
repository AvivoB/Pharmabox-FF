import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for Email widget.
  TextEditingController? emailController;
  String? Function(BuildContext, String?)? emailControllerValidator;
  // State field(s) for Motdepasse widget.
  TextEditingController? motdepasseController;
  late bool motdepasseVisibility;
  String? Function(BuildContext, String?)? motdepasseControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    motdepasseVisibility = false;
  }

  void dispose() {
    emailController?.dispose();
    motdepasseController?.dispose();
  }

  /// Additional helper methods are added here.

}
