import 'package:pharmabox/constant.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'list_skill_with_slider_model.dart';
export 'list_skill_with_slider_model.dart';

class ListSkillWithSliderWidget extends StatefulWidget {
  const ListSkillWithSliderWidget({
    Key? key,
    required this.slider,
  }) : super(key: key);

  final double? slider;

  @override
  _ListSkillWithSliderWidgetState createState() =>
      _ListSkillWithSliderWidgetState();
}

class _ListSkillWithSliderWidgetState extends State<ListSkillWithSliderWidget> {
  late ListSkillWithSliderModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListSkillWithSliderModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 0.0),
      child: Column(
      children: [
        Text(
          _currentStep == 0 ? 'Maîtrise basique' : _currentStep == 1 ? 'Maîtrise moyenne' : 'Maîtrise complète',
        ),
        Slider(
          value: _currentStep.toDouble(),
          min: 0,
          max: 2,
          divisions: 2,
          onChanged: (double value) {
            setState(() {
              _currentStep = value.toInt();
            });
          },
          activeColor: _currentStep == 0
              ? redColor
              : _currentStep == 1
                  ? yellowColor
                  : greenColor
        ),
        
      ],
    )
    );
  }
}
