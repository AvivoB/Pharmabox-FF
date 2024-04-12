import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmabox/constant.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/popups/popup_notifications/popup_notifications_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'header_app_model.dart';
export 'header_app_model.dart';

class HeaderAppWidget extends StatefulWidget {
  const HeaderAppWidget({Key? key}) : super(key: key);

  @override
  _HeaderAppWidgetState createState() => _HeaderAppWidgetState();
}

class _HeaderAppWidgetState extends State<HeaderAppWidget> {
  late HeaderAppModel _model;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HeaderAppModel());
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
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 1.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pharma-Box',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 5.0, 0.0),
                        child: Container(
                              decoration: BoxDecoration(
                                color: blueColor,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                    color: Color(0x33000000),
                                    offset: Offset(0.0, 5.0),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(200.0),
                              ),
                              child: FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 30.0,
                                borderWidth: 1.0,
                                buttonSize: 40.0,
                                icon: Icon(
                                  Icons.help_rounded,
                                  color: Colors.white,
                                  size: 25.0,
                                ),
                                onPressed: () async {
                                  context.pushNamed('HelperCenter');
                                },
                              ),
                            ),
                      ),
                      Stack(
                        alignment: AlignmentDirectional(2.0, -3.5),
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4.0,
                                  color: Color(0x33000000),
                                  offset: Offset(0.0, 5.0),
                                )
                              ],
                              borderRadius: BorderRadius.circular(200.0),
                            ),
                            child: FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 30.0,
                              borderWidth: 1.0,
                              buttonSize: 40.0,
                              icon: Icon(
                                Icons.notifications_none,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 25.0,
                              ),
                              onPressed: () async {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  enableDrag: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (bottomSheetContext) {
                                    return DraggableScrollableSheet(
                                        initialChildSize: 0.75,
                                        builder: (BuildContext context, ScrollController scrollController) {
                                          return Padding(
                                            padding: MediaQuery.of(bottomSheetContext).viewInsets,
                                            child: PopupNotificationsWidget(),
                                          );
                                        });
                                  },
                                ).then((value) => setState(() {}));
                              },
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('notifications').where('for', isEqualTo: currentUser?.uid).snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  // Display the error message
                                  print('${snapshot.error}');
                                }

                                final int unreadNotificationsCount = snapshot.data?.docs.length ?? 0;
                                if (unreadNotificationsCount > 0) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).alternate,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                                      child: Text(
                                        unreadNotificationsCount.toString(),
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Poppins',
                                              color: FlutterFlowTheme.of(context).primaryBackground,
                                              fontSize: 10.0,
                                            ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 5.0, 0.0),
                        child: Stack(
                          alignment: AlignmentDirectional(2.0, -3.5),
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                    color: Color(0x33000000),
                                    offset: Offset(0.0, 5.0),
                                  )
                                ],
                                gradient: LinearGradient(
                                  colors: [Color(0xFF42D2FF), Color(0xFF7CEDAC)],
                                  stops: [0.0, 1.0],
                                  begin: AlignmentDirectional(1.0, -1.0),
                                  end: AlignmentDirectional(-1.0, 1.0),
                                ),
                                borderRadius: BorderRadius.circular(200.0),
                              ),
                              child: FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 30.0,
                                borderWidth: 1.0,
                                buttonSize: 40.0,
                                icon: Icon(
                                  Icons.send_outlined,
                                  color: FlutterFlowTheme.of(context).primaryBackground,
                                  size: 25.0,
                                ),
                                onPressed: () async {
                                  context.pushNamed('Disucssions');
                                },
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collectionGroup('message').where('receiverId', isEqualTo: currentUser?.uid).where('isViewed', isEqualTo: false).snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    // Display the error message
                                    print('${snapshot.error}');
                                  }

                                  final int unreadMessagesCount = snapshot.data?.docs.length ?? 0;

                                  if (unreadMessagesCount > 0) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).alternate,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                                          child: Text(
                                            unreadMessagesCount.toString(),
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: 'Poppins',
                                                  color: FlutterFlowTheme.of(context).primaryBackground,
                                                  fontSize: 10.0,
                                                ),
                                          )),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                          ],
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
    );
  }
}
