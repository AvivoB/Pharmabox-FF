import 'package:flutter/material.dart';
import 'package:pharmabox/constant.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_theme.dart';

void showCustomSnackBar(BuildContext context, String message, {bool isError = false}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryBackground),
    ),
    backgroundColor: isError ? redColor : greenColor,
    duration: const Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
