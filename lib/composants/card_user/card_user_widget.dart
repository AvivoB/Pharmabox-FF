import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'card_user_model.dart';
export 'card_user_model.dart';

class CardUserWidget extends StatefulWidget {
  const CardUserWidget({Key? key}) : super(key: key);

  @override
  _CardUserWidgetState createState() => _CardUserWidgetState();
}

class _CardUserWidgetState extends State<CardUserWidget> {
  late CardUserModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CardUserModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 1.0,
      height: MediaQuery.of(context).size.height * 1.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                    child: Container(
                      width: 80.0,
                      height: 80.0,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/images/Group_18.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nom prénom',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Poppins',
                              color: Color(0xFF595A71),
                            ),
                      ),
                      Text(
                        'Poste',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Poppins',
                              color: Color(0xFF8D8D97),
                              fontSize: 13.0,
                            ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 0.0, 0.0),
                    child: Icon(
                      FFIcons.kbadgeOr,
                      color: FlutterFlowTheme.of(context).warning,
                      size: 35.0,
                    ),
                  ),
                ],
              ),
              Container(
                width: 30.0,
                height: 10.0,
                child: custom_widgets.GradientTextCustom(
                  width: 30.0,
                  height: 10.0,
                  text: 'Ajouter',
                  radius: 10.0,
                  fontSize: 14.0,
                  action: () async {},
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Color(0xFF595A71),
                size: 35.0,
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                child: Text(
                  '95200, Paris',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        color: Color(0xFF595A71),
                      ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 25.0, 0.0, 0.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 1.0,
              decoration: BoxDecoration(
                color: Color(0xFFEFF6F7),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '5555',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Poppins',
                                  fontSize: 13.0,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Color(0x00FFFFFF),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                3.0, 0.0, 3.0, 0.0),
                            child: FlutterFlowIconButton(
                              borderColor:
                                  FlutterFlowTheme.of(context).focusColor,
                              borderRadius: 30.0,
                              borderWidth: 2.0,
                              buttonSize: 40.0,
                              fillColor: Colors.white,
                              icon: Icon(
                                Icons.phone,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 20.0,
                              ),
                              onPressed: () {
                                print('IconButton pressed ...');
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                3.0, 0.0, 3.0, 0.0),
                            child: FlutterFlowIconButton(
                              borderColor:
                                  FlutterFlowTheme.of(context).focusColor,
                              borderRadius: 30.0,
                              borderWidth: 2.0,
                              buttonSize: 40.0,
                              fillColor:
                                  FlutterFlowTheme.of(context).primaryBtnText,
                              icon: Icon(
                                Icons.mail_outline_outlined,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 24.0,
                              ),
                              onPressed: () {
                                print('IconButton pressed ...');
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                3.0, 0.0, 3.0, 0.0),
                            child: FlutterFlowIconButton(
                              borderColor:
                                  FlutterFlowTheme.of(context).focusColor,
                              borderRadius: 30.0,
                              borderWidth: 1.0,
                              buttonSize: 40.0,
                              fillColor:
                                  FlutterFlowTheme.of(context).primaryBtnText,
                              icon: Icon(
                                Icons.message_sharp,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 22.0,
                              ),
                              onPressed: () {
                                print('IconButton pressed ...');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
