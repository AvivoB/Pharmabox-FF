import 'package:pharmabox/popups/popup_import_contact/popup_import_contact_model.dart';
import 'package:pharmabox/register_step/register_provider.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PopupImportContact extends StatefulWidget {
  const PopupImportContact({Key? key, required this.onTap}) : super(key: key);
  final Function onTap;

  @override
  _PopupImportContactState createState() => _PopupImportContactState();
}

class _PopupImportContactState extends State<PopupImportContact> {
  late PopupImportContactModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PopupImportContactModel());

    _model.lgoFilterController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1.0,
          height: MediaQuery.of(context).size.height * 0.30,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10.0, 15.0, 0.0, 15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Importez vos contacts',
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
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('Depuis vos numéros de téléphone', style: FlutterFlowTheme.of(context).bodyMedium),
                    onTap: () {
                      context.pushNamed('ReseauImportFromPhone');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.mail_outline),
                    title: Text('A partir de vos E-mails enregistrés', style: FlutterFlowTheme.of(context).bodyMedium),
                    onTap: () {
                      Navigator.of(context).pop(); // Fermer le BottomSheet
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.mail_outline),
                    title: Text('Envoyer des invitations par mail', style: FlutterFlowTheme.of(context).bodyMedium),
                    onTap: () {
                      // Fermer le BottomSheet
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
