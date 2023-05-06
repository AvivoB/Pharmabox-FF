import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'liste_prediction_model.dart';
export 'liste_prediction_model.dart';

class ListePredictionWidget extends StatefulWidget {
  const ListePredictionWidget({Key? key}) : super(key: key);

  @override
  _ListePredictionWidgetState createState() => _ListePredictionWidgetState();
}

class _ListePredictionWidgetState extends State<ListePredictionWidget> {
  late ListePredictionModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListePredictionModel());

    _model.nomFamilleController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1.0,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 1.0,
            height: 100.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
              child: TextFormField(
                controller: _model.nomFamilleController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Nom de famille',
                  hintStyle: FlutterFlowTheme.of(context).bodySmall,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFD0D1DE),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).focusColor,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
                style: FlutterFlowTheme.of(context).bodyMedium,
                validator:
                    _model.nomFamilleControllerValidator.asValidator(context),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.0, -0.46),
            child: Container(
              width: MediaQuery.of(context).size.width * 1.0,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
