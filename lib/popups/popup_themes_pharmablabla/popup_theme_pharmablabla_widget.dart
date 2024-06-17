import 'package:pharmabox/register_step/register_step_model.dart';

import '../../constant.dart';
import '../../register_step/register_provider.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'popup_theme_pharmablabla_model.dart';
export 'popup_theme_pharmablabla_model.dart';

class PopupThemePharmablablaWidget extends StatefulWidget {
  const PopupThemePharmablablaWidget({Key? key, required this.onTap}) : super(key: key);
  final Function onTap;

  @override
  _PopupThemePharmablablaWidgetState createState() => _PopupThemePharmablablaWidgetState();
}

class _PopupThemePharmablablaWidgetState extends State<PopupThemePharmablablaWidget> {
  late PopupThemePharmablablaModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PopupThemePharmablablaModel());

    _model.themePharmablabla ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  String? _search = '';

  @override
  Widget build(BuildContext context) {
    List<String> listSpecialite = PopupThemePharmablablaModel().getThemes().toList();

    List filtered = listSpecialite.where((item) => item.toLowerCase().contains(_search!.toLowerCase())).toList();

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Thème du post',
                              style: FlutterFlowTheme.of(context).displaySmall,
                            ),
                            FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderWidth: 0.0,
                              buttonSize: 60.0,
                              icon: Icon(
                                Icons.close,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 24.0,
                              ),
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1.0,
                    height: MediaQuery.of(context).size.height * 0.50,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(15.0, 5.0, 15.0, 5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              GestureDetector(
                                child: Text(filtered[index], style: FlutterFlowTheme.of(context).bodyMedium),
                                onTap: () {
                                  widget.onTap(filtered[index]);
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
