import 'package:pharmabox/constant.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SliderSimple extends StatefulWidget {
  const SliderSimple({
    Key? key, 
    required this.slider, 
    this.onChanged
  }): super(key: key);

  final double? slider;
  final Function(int)? onChanged;

  static void emptyFunction() {}

  @override
  _SliderSimpleState createState() =>
      _SliderSimpleState();
}

class _SliderSimpleState extends State<SliderSimple> {

  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 0.0),
        child: Column(
          children: [
            Slider(
                value: _currentStep.toDouble(),
                min: 0,
                max: 2,
                divisions: 2,
                onChanged: (double value) {
                  setState(() {
                    _currentStep = value.toInt();
                  });
                  widget.onChanged?.call(value.toInt());
                },
                activeColor: _currentStep == 0
                    ? redColor
                    : _currentStep == 1
                        ? yellowColor
                        : greenColor),
          ],
        ));
  }
}
