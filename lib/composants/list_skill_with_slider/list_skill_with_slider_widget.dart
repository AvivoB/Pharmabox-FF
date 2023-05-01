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

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 0.0),
      child: Slider(
        activeColor: FlutterFlowTheme.of(context).primary,
        inactiveColor: FlutterFlowTheme.of(context).accent2,
        min: 0.0,
        max: 3.0,
        value: _model.sliderValue ??= widget.slider!,
        onChanged: (newValue) {
          newValue = double.parse(newValue.toStringAsFixed(4));
          setState(() => _model.sliderValue = newValue);
        },
      ),
    );
  }
}
