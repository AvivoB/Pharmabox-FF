import 'package:flutter/material.dart';
import 'package:pharmabox/constant.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_theme.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';

void showCustomSnackBar(BuildContext context, String message, {bool isError = false}) {
  Flushbar(
    message: message,
    duration: Duration(seconds: 3),
    backgroundColor: isError ? redColor : greenColor,
  )..show(context);

  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(
      message,
      style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryBackground),
    ),
    backgroundColor: isError ? redColor : greenColor,
    duration: const Duration(seconds: 3),
  );

  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
