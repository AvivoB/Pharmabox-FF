// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:simple_gradient_text/simple_gradient_text.dart';

class GradientTextCustom extends StatefulWidget {
  const GradientTextCustom({
    Key? key,
    this.width,
    this.height,
    required this.text,
    required this.radius,
    required this.fontSize,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String text;
  final double radius;
  final double fontSize;

  @override
  _GradientTextCustomState createState() => _GradientTextCustomState();
}

class _GradientTextCustomState extends State<GradientTextCustom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GradientText(
          this.widget.text,
          radius: this.widget.radius,
          style: TextStyle(
            fontSize: this.widget.fontSize,
            fontWeight: FontWeight.w400,
          ),
          colors: [Color(0xff7CEDAC), Color(0xFF42D2FF)],
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 2.0,
          ),
        ],
      ),
    );
  }
}
